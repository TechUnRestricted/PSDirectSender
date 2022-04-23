//
//  PSDirectSenderApp.swift
//  PSDirectSender
//
//  Created by Macintosh on 22.04.2022.
//

import SwiftUI

let networking = Networking()
let server = MyClass()

@main
struct PSDirectSenderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 650,
                       idealWidth: 750,
                       maxWidth: .infinity,
                       minHeight: 340,
                       idealHeight: 440,
                       maxHeight: .infinity
                )
                .navigationSubtitle("for Remote Package Installer")
        }
    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
extension Int {
    func isInRange(_ start: Int, _ end: Int) -> Bool{
        return self >= start && self <= end
    }
}

