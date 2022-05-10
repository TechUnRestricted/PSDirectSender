//
//  ScreenView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI


struct ScreenView: View {
    let screen: Screen
    @EnvironmentObject var vm: ConnectionDetails
    
    var body: some View {
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
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let view = ScreenView(screen: .info)
        view
        view
            .environment(\.locale, .init(identifier: "Russian"))
    }
}
