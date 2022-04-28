//
//  ScreenView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI


struct ScreenView: View {
    let screen : Screen
    @EnvironmentObject var vm: ConnectionDetails
    
    var body: some View {
        switch(screen){
        case .queue:
            QueueView()
        case .configuration:
            ConfigurationView()
        case .logs:
            Text("Logs")
        case .info:
            Text("Info")
        }
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView(screen: .info)
    }
}
