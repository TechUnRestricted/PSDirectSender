//
//  LogsView.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.04.2022.
//

import SwiftUI

struct LogsView: View {
    @EnvironmentObject var connection: ConnectionDetails
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                ColorButton(text: "Copy logs", color: .purple, image: Image(systemName: "doc.on.doc"), action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(connection.logLines.joined(separator: "\n"), forType: .string)
                })
                
                ColorButton(text: "Clear logs", color: .red, image: Image(systemName: "trash"), action: {
                    connection.logLines.removeAll()
                })
            }.padding()
            List {
                ForEach(connection.logLines, id: \.self) { logLine in
                    Text(LocalizedStringKey(logLine))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .swiftyListDivider()
                }
            }.overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
            )
        }.padding()
    }
}

struct LogsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = LogsView()
            .environmentObject({ () -> ConnectionDetails in
                let vm = ConnectionDetails()
                vm.addLog("Can't get server configuration.")
                vm.addLog("Can't get console configuration.")
                vm.addLog("Creating package alias \(#""/Volumes/Macintosh HD/game.pkg""#) -> \"\(tempDirectory.path)\(UUID().uuidString).pkg\"")
                
                return vm
            }())
        view
        view
            .environment(\.locale, .init(identifier: "Russian"))
        
    }
}
