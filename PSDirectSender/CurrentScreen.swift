//
//  CurrentScreen.swift
//  PSDirectSender
//
//  Created by Macintosh on 06.03.2022.
//

import SwiftUI

struct ScreenView: View {
    let screen : Screen
    
    var body: some View {
        ScrollView(.vertical){
            switch(screen){
            case .queue:
                QueueView()
            case .configuration:
                ConfigurationView()
            case .logs:
                LogsView()
            case .info:
                InfoView()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

        
    }
}



