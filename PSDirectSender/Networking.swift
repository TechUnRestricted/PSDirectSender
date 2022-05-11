//
//  Networking.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import Foundation
import SystemConfiguration

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
    private func _IOWR (_ group: Character , _ num: UInt32, _ size: UInt32) -> UInt32 {
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
        let storeRef = SCDynamicStoreCreate(nil, "FindCurrentInterfaceIpMac" as CFString, nil, nil)
        let global = SCDynamicStoreCopyValue(storeRef, "State:/Network/Interface" as CFString)
        let primaryInterfaces = (global as? [AnyHashable: Any])?["Interfaces"] as? [String]
        if let primaryInterfaces = primaryInterfaces{
            let filteredNames = primaryInterfaces.filter({ $0.hasPrefix("en") })
            return filteredNames
        }
        return []
    }
    
    enum BaseURLError: Error {
        case invalidIP
        case invalidPort
    }
    
    public func checkIfPortIsCorrect(port: String) -> Bool{
        if let port = Int(port){
            return port.isInRange(0, 65535)
        }
        return false
    }
    
    public func checkIfIPIsCorrect(ip: String) -> Bool{
        return ip.matches(#"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$"#)
    }
    
    public func buildServerBaseURL(ip: String, port: Int, ignoreChecks: Bool = false) throws -> String{
        if (!ignoreChecks){
            guard (checkIfIPIsCorrect(ip: ip)) else {
                throw BaseURLError.invalidIP
            }
            guard (checkIfPortIsCorrect(port: String(port))) else {
                throw BaseURLError.invalidPort
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
    
    func findFreePort() -> UInt16 {
        var port: UInt16 = 8000;
        
        let socketFD = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        if socketFD == -1 {
            //print("Error creating socket: \(errno)")
            return port;
        }
        
        var hints = addrinfo(
            ai_flags: AI_PASSIVE,
            ai_family: AF_INET,
            ai_socktype: SOCK_STREAM,
            ai_protocol: 0,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil
        );
        
        var addressInfo: UnsafeMutablePointer<addrinfo>? = nil;
        var result = getaddrinfo(nil, "0", &hints, &addressInfo);
        if result != 0 {
            //print("Error getting address info: \(errno)")
            close(socketFD);
            
            return port;
        }
        
        result = Darwin.bind(socketFD, addressInfo!.pointee.ai_addr, socklen_t(addressInfo!.pointee.ai_addrlen));
        if result == -1 {
            //print("Error binding socket to an address: \(errno)")
            close(socketFD);
            
            return port;
        }
        
        result = Darwin.listen(socketFD, 1);
        if result == -1 {
            //print("Error setting socket to listen: \(errno)")
            close(socketFD);
            
            return port;
        }
        
        var addr_in = sockaddr_in();
        addr_in.sin_len = UInt8(MemoryLayout.size(ofValue: addr_in));
        addr_in.sin_family = sa_family_t(AF_INET);
        
        var len = socklen_t(addr_in.sin_len);
        result = withUnsafeMutablePointer(to: &addr_in, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                return Darwin.getsockname(socketFD, $0, &len);
            }
        });
        
        if result == 0 {
            port = addr_in.sin_port;
        }
        
        Darwin.shutdown(socketFD, SHUT_RDWR);
        close(socketFD);
        
        return port;
    }
    
}
