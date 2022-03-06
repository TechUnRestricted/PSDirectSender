//
//  PSDirectSenderApp.swift
//  PSDirectSender
//
//  Created by Macintosh on 05.03.2022.
//

import SwiftUI

@main
struct PSDirectSenderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .navigationSubtitle("for Remote Package Installer")
        }
    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
