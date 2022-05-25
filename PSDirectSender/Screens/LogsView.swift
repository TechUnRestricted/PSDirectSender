//
//  LogsView.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.04.2022.
//

import SwiftUI

struct LogsView: View {
    @EnvironmentObject var connection: ConnectionDetails
    @EnvironmentObject var logsCollector: LogsCollector

    var body: some View {
        VStack {
            HStack(spacing: 25) {
                ColorButton(text: "Copy logs", color: .purple, image: Image(systemName: "doc.on.doc"), action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(logsCollector.logLines.joined(separator: "\n"), forType: .string)
                })
                
                ColorButton(text: "Clear logs", color: .red, image: Image(systemName: "trash"), action: {
                    logsCollector.logLines.removeAll()
                })
            }.padding()
            List {
                ForEach(logsCollector.logLines, id: \.self) { logLine in
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
            .environmentObject({ () -> LogsCollector in
                let logsCollector = LogsCollector()
                logsCollector.addLog("Can't get server configuration.")
                logsCollector.addLog("Can't get console configuration.")
                logsCollector.addLog("Creating package alias \(#""/Volumes/Macintosh HD/game.pkg""#) -> \"\(tempDirectory.path)\(UUID().uuidString).pkg\"")
                return logsCollector
            }())
        view
        view
            .environment(\.locale, .init(identifier: "Russian"))
        
    }
}
