//
//  AppDelegate.swift
//  PSDirectSender
//
//  Created by Macintosh on 28.06.2022.
//

import Cocoa



var titlebarHeight: CGFloat = 0

class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 270),
            styleMask: [.miniaturizable, .closable, .resizable, .titled, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.title = "No Storyboard Window"
        window.makeKeyAndOrderFront(nil)
        
        let toolbar = NSToolbar(identifier: UUID().uuidString)
        toolbar.allowsUserCustomization = true
        window.toolbar = toolbar
        
        if let windowFrameHeight = window?.contentView?.frame.height,
            let contentLayoutRectHeight = window?.contentLayoutRect.height {
            let fullSizeContentViewNoContentAreaHeight = windowFrameHeight - contentLayoutRectHeight
            titlebarHeight = fullSizeContentViewNoContentAreaHeight
        }
        window.contentViewController = SplitViewController()
        //window.titlebarAppearsTransparent = true

        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
}

