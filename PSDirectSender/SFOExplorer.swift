//
//  SFOExplorer.swift
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

class SFOExplorer {
    private func loadFileDataBlocks(from offset: UInt64, bytesCount: Int, fileHandler: FileHandle) -> Data {
        try? fileHandler.seek(toOffset: offset)
        let data = fileHandler.readData(ofLength: bytesCount)
        return data
    }
    
    private struct PKGTableEntry {
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
    
    private func decodePackageTableEntry(data: Data) -> [PKGTableEntry] {
        let converted = data.withUnsafeBytes {
            Array($0.bindMemory(to: PKGTableEntry.self))
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
    
    private func getParamSFOOffset(fileHandler: FileHandle) -> UInt32? {
        guard let filesCount = loadFileDataBlocks(from: 0x00C,
                                                  bytesCount: 4,
                                                  fileHandler: fileHandler)
                .integerRepresentation?
                .bigEndian
        else { return nil }
        
        if filesCount >= 256 {
            print("[ERROR:] Files count >= 256 (current: \(filesCount)). It's can't be real.")
            return nil
        }
        
        guard let tableOffset = loadFileDataBlocks(from: 0x018,
                                                   bytesCount: 4,
                                                   fileHandler: fileHandler)
                .integerRepresentation?
                .bigEndian
        else { return nil }
        
        let tableData = loadFileDataBlocks(
            from: UInt64(tableOffset),
            bytesCount: MemoryLayout<PKGTableEntry>.size * Int(filesCount),
            fileHandler: fileHandler)
        
        let tableStruct = decodePackageTableEntry(data: tableData)
        
        for table in tableStruct where table.id == 1048576 {
            return table.offset
        }
        
        return nil
    }
    
    func getParamSFOData(url: URL) -> [String: String]? {
        do {
            let fileHandler: FileHandle = try .init(forReadingFrom: url)
            return getParamSFOData(fileHandler: fileHandler)
        } catch { }
        return nil
    }
    
    func getParamSFOData(fileHandler: FileHandle) -> [String: String] {
        /// MAGIC
        /*
         let magic: Int32 = loadFileDataBlocks(
         from: 0,
         bytesCount: 4,
         fileHandler: fileHandler
         ).integerRepresentation
         */
        
        /// PARAM.SFO
        guard let offset32: UInt32 = getParamSFOOffset(fileHandler: fileHandler) else {
            return [:]
        }
        
        /*if offset32 != 1414415231 {
         print("Invalid PKG")
         return [:]
         }*/
        
        var offset: UInt64 = UInt64(offset32.bigEndian)
        
        /// HEADER
        let headerData = loadFileDataBlocks(
            from: UInt64(offset),
            bytesCount: MemoryLayout<Header>.size, fileHandler: fileHandler)
        let headerVariable = decodeHeader(data: headerData)
        
        offset += UInt64(MemoryLayout<Header>.size)
        
        /// ENTRIES
        let entriesSize: UInt32 = UInt32(MemoryLayout<IndexTableEntry>.size) * headerVariable.entriesCount
        let entriesData = loadFileDataBlocks(from: offset, bytesCount: Int(entriesSize), fileHandler: fileHandler)
        let entriesVariable = decodeEntries(data: entriesData)
        
        offset += UInt64(entriesSize)
        
        /// TABLE
        let tableSize = Int(headerVariable.dataTableOffset - headerVariable.keyTableOffset)
        let tableData = loadFileDataBlocks(from: offset, bytesCount: tableSize, fileHandler: fileHandler)
        
        offset += UInt64(tableSize)
        
        /// Сonnecting parameters to data
        let parameters: [String] = tableData.stringRepresentation.components(separatedBy: "\0")
        var values: [String] = .init()
        
        for entry in entriesVariable {
            let entryData = loadFileDataBlocks(
                from: offset + UInt64(entry.dataOffset),
                bytesCount: Int(entry.paramLen),
                fileHandler: fileHandler)
            
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
