//
//  ConnectionDetails.swift
//  PSDirectSender
//
//  Created by Macintosh on 28.04.2022.
//

import Foundation

class LogsCollector: ObservableObject {
    @Published var logLines: [String] = []
    func addLog(_ text: String) {
        DispatchQueue.main.async {
            self.logLines.append("[\(getStringDate())] \(text)")
        }
    }
}

class ConnectionDetails: ObservableObject {
    @Published var serverIP: String = ""
    @Published var serverPort: String = ""
    @Published var consoleIP: String = ""
    @Published var consolePort: String = "12800"
    @Published var connectionStatus: ServerStatus = .stopped
    @Published var networkingIPs: [String] = []
    
    func generateServerDetails() {
        serverPort = String(networking.findFreePort())
        
        networkingIPs = networking.getIPNetworkAddresses()
        if let ip = networkingIPs.first {
            serverIP = ip
        }
    }
}
