//
//  SidebarButton.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

fileprivate extension Screen {
    var imageView: Image {
        switch self {
        case .queue:
            return Image(systemName: "list.bullet")
        case .configuration:
            return Image(systemName: "gearshape")
        case .logs:
            return Image(systemName: "contextualmenu.and.cursorarrow")
        case .info:
            return Image(systemName: "info.circle")
        }
    }
    
    var textView: Text {
        switch self {
        case .queue:
            return Text("Queue")
        case .configuration:
            return Text("Configuration")
        case .logs:
            return Text("Logs")
        case .info:
            return Text("Info")
        }
    }
}

struct SidebarButton: View {
    let type: Screen
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            type.imageView
                .frame(width: 15, alignment: .center)
                .padding(8)
                .font(Font.body.weight(.light))
            type.textView
        }.frame(height: 30)
    }
    
}

struct SidebarButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Screen.allCases, id: \.self) { screen in
            SidebarButton(type: screen)
        }
    }
}
