//
//  ScreenView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct ScreenView: View {
    let screen : Screen
    
    @State var serverIP : String = ""
    @State var serverPort : String = "15460"
    @State var consoleIP : String = ""
    @State var consolePort : String = "12800"
    
    var body: some View {
        switch(screen){
        case .queue:
            QueueView(
                serverIP: $serverIP,
                serverPort: $serverPort,
                consoleIP: $consoleIP,
                consolePort: $consolePort
            )
        case .configuration:
            ConfigurationView(
                serverIP: $serverIP,
                serverPort: $serverPort,
                consoleIP: $consoleIP,
                consolePort: $consolePort
            )
        case .logs:
            Text("Logs")
        case .info:
            Text("Info")
        }
    }
}
