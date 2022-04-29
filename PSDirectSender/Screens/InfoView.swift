//
//  InfoView.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.04.2022.
//

import SwiftUI

struct InfoView: View {
    @State private var showingPopover = false
    
    var body: some View {
        VStack{
            HStack{
                Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                    .resizable()
                    .frame(width: 80, height: 80)
                VStack(alignment: .leading){
                    Text("PSDirectSender")
                        .font(.title)
                        .opacity(0.9)
                    Text("for Remote Package Installer")
                        .font(.title3)
                        .opacity(0.6)
                    Text("Version: \(Bundle.main.appVersionLong)")
                        .opacity(0.9)
                        .font(.footnote)
                }
            }
            VStack(alignment: .leading, spacing: 10){
                Text("This software is distributed under the Apache License, Version 2.0.")
                Text("This software contains a third-party library \"Mongoose - Embedded Web Server\" which is distributed under the GNU General Public License, version 2")
            }.font(.caption2)
                .opacity(0.5)
                .padding()
            Button("View Open Source Licenses"){
                showingPopover.toggle()
            }.buttonStyle(LinkButtonStyle())
                .popover(isPresented: $showingPopover) {
                    Text("""
Mongoose - Embedded Web Server (https://github.com/cesanta/mongoose)

Copyright (c) 2004-2013 Sergey Lyubka
Copyright (c) 2013-2021 Cesanta Software Limited
All rights reserved

This software is dual-licensed: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation. For the terms of this
license, see <http://www.gnu.org/licenses/>.

You are free to use this software under the terms of the GNU General
Public License, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

Alternatively, you can license this software under a commercial
license, as set out in <https://mongoose.ws/licensing/>.
""").padding()
                }
        }.frame(width: 400, height: 280)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .frame(width: 400, height: 280)
    }
}
