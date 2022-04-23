//
//  ScreenView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct ScreenView: View {
    let screen : Screen
    
    var body: some View {
        switch(screen){
        case .queue:
            Text("Queue")
        case .configuration:
            ConfigurationView()
        case .logs:
            Text("Logs")
        case .info:
            Text("Info")
        }
    }
}
