//
//  SidebarButton.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct SidebarButton: View {
    let type: Screen
    var body: some View {
        let imageWidth: CGFloat = 15
        HStack {
            switch type {
            case .queue:
                Image(systemName: "square.and.pencil").frame(width: imageWidth, alignment: .center)
                Text("Queue")
            case .configuration:
                Image(systemName: "gearshape").frame(width: imageWidth, alignment: .center)
                Text("Configuration")
            case .logs:
                Image(systemName: "contextualmenu.and.cursorarrow").frame(width: imageWidth, alignment: .center)
                Text("Logs")
            case .info:
                Image(systemName: "info.circle").frame(width: imageWidth, alignment: .center)
                Text("Info")
            }
        }
    }
}

struct SidebarButton_Previews: PreviewProvider {
    static var previews: some View {
        SidebarButton(type: .configuration)
    }
}
