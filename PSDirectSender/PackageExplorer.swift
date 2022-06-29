//
//  PackageExplorer.swift
//  PSDirectSender
//
//  Created by Macintosh on 21.05.2022.
//

import Foundation

fileprivate extension Data {
    var integerRepresentation: Int32? {
        if self.count < MemoryLayout<Int32>.size {
            return nil
        } else {
            return self.withUnsafeBytes({(pointer: UnsafeRawBufferPointer) -> Int32 in
                return pointer.load(as: Int32.self)
            })
        }
    }
    var stringRepresentation: String {
        return String(decoding: self, as: UTF8.self)
    }
}

fileprivate extension Dictionary where Value: Equatable {
    func valueForKey(_ val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

/* Big Endian */
fileprivate let packageFileNamesMap: [UInt32: String] = [
    0x0400: "license.dat",
    0x0401: "license.info",
    0x1000: "param.sfo",
    0x1001: "playgo-chunk.dat",
    0x1002: "playgo-chunk.sha",
    0x1003: "playgo-manifest.xml",
    0x1004: "pronunciation.xml",
    0x1005: "pronunciation.sig",
    0x1006: "pic1.png",
    0x1008: "app/playgo-chunk.dat",
    0x1200: "icon0.png",
    0x1220: "pic0.png",
    0x1240: "snd0.at9",
    0x1260: "changeinfo/changeinfo.xml"
]

class PackageExplorer {
    
    private func loadFileDataBlocks(from offset: UInt64, bytesCount: Int, fileHandler: FileHandle) -> Data? {
        do {
            if #available(macOS 10.15, *) {
                try fileHandler.seek(toOffset: offset)
            } else {
                fileHandler.seek(toFileOffset: offset)
            }
            return fileHandler.readData(ofLength: bytesCount)
        } catch {
            print("[ERROR:] Can't load file data blocks")
        }
        return nil
    }
    
    struct PackageContents {
        let files: [PKGTableEntry]?
        let paramSFOData: [String: String]?
    }
    
    struct PKGTableEntry {
        let filename: String?
        
        let id: UInt32
        let filenameOffset: UInt32
        let flags1: UInt32
        let flags2: UInt32
        let offset: UInt32
        let size: UInt32
        let padding: UInt64
        
    }
    
    private struct PKGTableEntryLittleEndian {
        let id: UInt32
        let filenameOffset: UInt32
        let flags1: UInt32
        let flags2: UInt32
        let offset: UInt32
        let size: UInt32
        let padding: UInt64
    }
    
    private struct Header {
        let magic: UInt32
        let version: UInt32
        let keyTableOffset: UInt32
        let dataTableOffset: UInt32
        let entriesCount: UInt32
    }
    
    private struct IndexTableEntry {
        let keyOffset: UInt16
        let paramFmt: UInt16
        let paramLen: UInt32
        let paramMaxLen: UInt32
        let dataOffset: UInt32
    }
    
    private func decodePackageTableEntry(data: Data) -> [PKGTableEntryLittleEndian] {
        /* Decoding as Little Endian. (needs to be converted to Big Endian)*/
        
        let converted = data.withUnsafeBytes {
            Array($0.bindMemory(to: PKGTableEntryLittleEndian.self))
        }
        return converted
    }
    
    private func decodeHeader(data: Data) -> Header {
        let converted = data.withUnsafeBytes {
            $0.load(as: Header.self)
        }
        return converted
    }
    
    private func decodeEntries(data: Data) -> [IndexTableEntry] {
        let converted = data.withUnsafeBytes {
            Array($0.bindMemory(to: IndexTableEntry.self))
        }
        return converted
    }
    
    private var fileHandler: FileHandle?
    var packageContents: PackageContents?
    
    init(fileHandler: FileHandle) {
        self.fileHandler = fileHandler
        self.packageContents = self.getPackageContents()
    }
    
    init(fileURL: URL) {
        if let fileHandler = try? FileHandle(forReadingFrom: fileURL) {
            self.fileHandler = fileHandler
        }
        self.packageContents = self.getPackageContents()
    }
    
    init(filePath: String) {
        if let url = URL(string: filePath), let fileHandler = try? FileHandle(forReadingFrom: url) {
            self.fileHandler = fileHandler
        }
        self.packageContents = self.getPackageContents()
    }
    
    func getData(entry: PKGTableEntry) -> Data? {
        if let fileHandler = fileHandler {
            return loadFileDataBlocks(from: UInt64(entry.offset), bytesCount: Int(entry.size), fileHandler: fileHandler)
        }
        return nil
    }
        
    private func getTableData() -> [PKGTableEntryLittleEndian]? {
        guard let fileHandler = fileHandler else {
            return nil
        }
        
        guard let entriesCount = loadFileDataBlocks(from: 0x10,
                                                    bytesCount: 4,
                                                    fileHandler: fileHandler)?
                .integerRepresentation?
                .bigEndian
        else { return nil }
        
        if entriesCount > 256 {
            print("[ERROR:] Entries count > 256 (current: \(entriesCount)). This can't be real.")
            return nil
        }
        
        guard let tableOffset = loadFileDataBlocks(from: 0x018,
                                                   bytesCount: 4,
                                                   fileHandler: fileHandler)?
                .integerRepresentation?
                .bigEndian
        else { return nil }
        
        let tableData = loadFileDataBlocks(
            from: UInt64(tableOffset),
            bytesCount: MemoryLayout<PKGTableEntryLittleEndian>.size * Int(entriesCount),
            fileHandler: fileHandler)
        
        if let tableData = tableData {
            return decodePackageTableEntry(data: tableData)
        }
        
        return nil
    }
    
    func packageIsValid() -> Bool {
        guard let fileHandler = fileHandler else {
            return false
        }
        
        let magic = loadFileDataBlocks(from: 0x0,
                                       bytesCount: 4,
                                       fileHandler: fileHandler)?
            .integerRepresentation
        
        return magic?.bigEndian == 0x7F434E54
    }
    
    private func getPackageContents() -> PackageContents? {
        if !packageIsValid() {
            print("[ERROR:] Package is Invalid")
            return nil
        }
        
        let tableData = getTableData()
        
        var packageEntries: [PKGTableEntry]?
        var paramSFOData: [String: String]?
        
        if let tableData = tableData {
            packageEntries = .init()
            
            for table in tableData {
                let bigEndianEntry: PKGTableEntry = .init(
                    filename: packageFileNamesMap[table.id.bigEndian],
                    id: table.id.bigEndian,
                    filenameOffset: table.filenameOffset.bigEndian,
                    flags1: table.flags1.bigEndian,
                    flags2: table.flags2.bigEndian,
                    offset: table.offset.bigEndian,
                    size: table.size.bigEndian,
                    padding: table.padding.bigEndian
                )
                packageEntries!.append(bigEndianEntry)
                
                if bigEndianEntry.id == packageFileNamesMap.valueForKey("param.sfo") {
                    paramSFOData = getParamSFOData(paramSFOOffset: bigEndianEntry.offset)
                }
            }
            
        }
        
        return PackageContents(files: packageEntries, paramSFOData: paramSFOData)
    }
    
    private func getParamSFOData(paramSFOOffset: UInt32) -> [String: String]? {
        
        guard let fileHandler = fileHandler else {
            return nil
        }
        
        var offset: UInt64 = UInt64(paramSFOOffset)
        
        /// HEADER
        guard let headerData = loadFileDataBlocks(
            from: UInt64(offset),
            bytesCount: MemoryLayout<Header>.size, fileHandler: fileHandler) else {
                return nil
            }
        let headerVariable = decodeHeader(data: headerData)
        
        offset += UInt64(MemoryLayout<Header>.size)
        
        /// ENTRIES
        let entriesSize: UInt32 = UInt32(MemoryLayout<IndexTableEntry>.size) * headerVariable.entriesCount
        guard let entriesData = loadFileDataBlocks(from: offset, bytesCount: Int(entriesSize), fileHandler: fileHandler) else {
            return nil
        }
        let entriesVariable = decodeEntries(data: entriesData)
        
        offset += UInt64(entriesSize)
        
        /// TABLE
        let tableSize = Int(headerVariable.dataTableOffset - headerVariable.keyTableOffset)
        let tableData = loadFileDataBlocks(from: offset, bytesCount: tableSize, fileHandler: fileHandler)
        
        offset += UInt64(tableSize)
        
        /// Сonnecting parameters to data
        guard let tableData = tableData else {
            return nil
        }
        
        let parameters: [String] = tableData.stringRepresentation.components(separatedBy: "\0")
        var values: [String] = .init()
        
        for entry in entriesVariable {
            guard let entryData = loadFileDataBlocks(
                from: offset + UInt64(entry.dataOffset),
                bytesCount: Int(entry.paramLen),
                fileHandler: fileHandler) else {
                    continue
                }
            
            switch entry.paramFmt {
            case 516, 1024:
                /* String */
                values.append(entryData.stringRepresentation.replacingOccurrences(of: "\0", with: ""))
            case 1028:
                /* Integer */
                values.append(String(entryData.integerRepresentation ?? -1))
            default:
                break
            }
        }
        let paramSFOData = Dictionary(uniqueKeysWithValues: zip(parameters, values))
        
        return paramSFOData
    }
}
