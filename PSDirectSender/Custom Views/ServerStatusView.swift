//
//  ConnectionStatusView.swift
//  PSDirectSender
//
//  Created by Macintosh on 28.04.2022.
//

import SwiftUI

enum ServerStatus {
    case success
    case fail
    case stopped
}

struct ServerStatusView: View {
    @Binding var serverStatus: ServerStatus
    
    var colorToShow: Color {
        switch serverStatus {
        case .success:
            return .green
        case .fail:
            return .red
        case .stopped:
            return .gray
        }
    }
    
    var textToShow: LocalizedStringKey {
        switch serverStatus {
        case .success:
            return "Success"
        case .fail:
            return "Failed"
        case .stopped:
            return "Stopped"
        }
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .strokeBorder(
                    Color.black.opacity(0.5),
                    lineWidth: 2
                )
                .background(Circle().fill(colorToShow))
                .frame(width: 18, height: 18)
            Text(textToShow)
                .font(.title3)
        }
    }
}

struct ConnectionStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStatusView(serverStatus: .constant(.fail))
            .frame(width: 200, height: 100)
    }
}
