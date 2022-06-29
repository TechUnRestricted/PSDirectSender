//
//  LogsViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.06.2022.
//

import Foundation
import Cocoa

class LogsViewController: NSViewController {
        
    init() {
        print("Initialized \(#function): \(arc4random())")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let nsView = NSView()
        nsView.wantsLayer = true
        nsView.layer?.backgroundColor = .white
        view = nsView
    }
}
