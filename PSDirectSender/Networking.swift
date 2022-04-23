//
//  Networking.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import Foundation

class Networking{
    private enum AddressRequestType {
        case ipAddress
        case netmask
    }
    
    // From BDS ioccom.h
    // Macro to create ioctl request
    private func _IOC (_ io: UInt32, _ group: UInt32, _ num: UInt32, _ len: UInt32) -> UInt32 {
        let rv = io | (( len & UInt32(IOCPARM_MASK)) << 16) | ((group << 8) | num)
        return rv
    }
    
    // Macro to create read/write IOrequest
    private func _IOWR (_ group: Character , _ num : UInt32, _ size: UInt32) -> UInt32 {
        return _IOC(IOC_INOUT, UInt32 (group.asciiValue!), num, size)
    }
    
    private func _interfaceAddressForName (_ name: String, _ requestType: AddressRequestType) throws -> String {
        
        var ifr = ifreq ()
        ifr.ifr_ifru.ifru_addr.sa_family = sa_family_t(AF_INET)
        
        // Copy the name into a zero padded 16 CChar buffer
        
        let ifNameSize = Int (IFNAMSIZ)
        var b = [CChar] (repeating: 0, count: ifNameSize)
        strncpy (&b, name, ifNameSize)
        
        // Convert the buffer to a 16 CChar tuple - that's what ifreq needs
        ifr.ifr_name = (b [0], b [1], b [2], b [3], b [4], b [5], b [6], b [7], b [8], b [9], b [10], b [11], b [12], b [13], b [14], b [15])
        
        let ioRequest: UInt32 = {
            switch requestType {
            case .ipAddress: return _IOWR("i", 33, UInt32(MemoryLayout<ifreq>.size))    // Magic number SIOCGIFADDR - see sockio.h
            case .netmask: return _IOWR("i", 37, UInt32(MemoryLayout<ifreq>.size))      // Magic number SIOCGIFNETMASK
            }
        } ()
        
        if ioctl(socket(AF_INET, SOCK_DGRAM, 0), UInt(ioRequest), &ifr) < 0 {
            throw POSIXError (POSIXErrorCode (rawValue: errno) ?? POSIXErrorCode.EINVAL)
        }
        
        let sin = unsafeBitCast(ifr.ifr_ifru.ifru_addr, to: sockaddr_in.self)
        let rv = String (cString: inet_ntoa (sin.sin_addr))
        
        return rv
    }
    
    public func getInterfaceIPAddress (interfaceName: String) throws -> String {
        return try _interfaceAddressForName(interfaceName, .ipAddress)
    }
    
    public func getInterfaceNetMask (interfaceName: String) throws -> String {
        return try _interfaceAddressForName(interfaceName, .netmask)
    }
    
    public func interfaceNames() -> [String] {
        
        let MAX_INTERFACES = 128;
        
        var interfaceNames = [String]()
        let interfaceNamePtr = UnsafeMutablePointer<Int8>.allocate(capacity: Int(Int(IF_NAMESIZE)))
        for interfaceIndex in 1...MAX_INTERFACES{
            if (if_indextoname(UInt32(interfaceIndex), interfaceNamePtr) != nil){
                let interfaceName = String(cString: interfaceNamePtr)
                if (interfaceName.hasPrefix("en")){
                    interfaceNames.append(interfaceName)
                }
            } else {
                break
            }
        }
        
        interfaceNamePtr.deallocate()
        return interfaceNames
    }
    
    private enum BaseURLError: Error {
        case invalidIP(String)
        case invalidPort(String)
    }
    
    public func buildServerBaseURL(ip: String, port: Int, ignoreChecks: Bool = false) throws -> String{
        if (!ignoreChecks){
            guard (ip.matches(#"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$"#)) else {
                throw BaseURLError.invalidIP("IP address is not valid.")
            }
            guard (port.isInRange(0, 65535)) else {
                throw BaseURLError.invalidPort("Port is not in a [0, 65535] range.")
            }
        }
        return "\(ip):\(port)"
    }
    
    public func getIPNetworkAddresses() -> [String]{
        var IPAddresses: [String] = []
        for interface in interfaceNames(){
            if let ip = try? getInterfaceIPAddress(interfaceName: interface){
                IPAddresses.append(ip)
            }
        }
        return IPAddresses
    }
    
}
