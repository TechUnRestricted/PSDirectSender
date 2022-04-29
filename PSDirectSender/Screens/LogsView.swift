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
        VStack{
            HStack(spacing: 25){
            ColorButton(text: "Copy logs", color: .purple, image: Image(systemName: "doc.on.doc"), handler: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(connection.logLines.joined(separator: "\n"), forType: .string)
            })
            
            ColorButton(text: "Clear logs", color: .red, image: Image(systemName: "trash"), handler: {
                connection.logLines = []
            })
            }.padding()
            List(){
                ForEach(connection.logLines, id: \.self) { logLine in
                    Text(logLine)
                        .frame(maxWidth: .infinity)
                        .swiftyListDivider()
                }
            }.overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 2)
            )
        }.padding()
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}