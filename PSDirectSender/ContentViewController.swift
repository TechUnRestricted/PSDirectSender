//
//  ContentViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Cocoa

class ContentViewController: NSViewController {
    
    let tabView = NSTabView()

    init() {
        print("Initialized \(#function): \(arc4random())")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTab(index: Int) {
        tabView.selectTabViewItem(at: index)
    }
    
    override func loadView() {
        let nsView = NSView()
        nsView.wantsLayer = true
        nsView.layer?.backgroundColor = NSColor.red.cgColor
        
        tabView.addTabViewItem(NSTabViewItem(viewController: FirstView()))
        tabView.addTabViewItem(NSTabViewItem(viewController: SecondView()))
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.tabViewType = .noTabsNoBorder
        
        nsView.addSubview(tabView)
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: tabView,
                attribute: .top,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .top,
                multiplier: 1.0,
                constant: titlebarHeight
            )
        )
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: tabView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0
            )
        )

        nsView.addConstraint(
            NSLayoutConstraint(
                item: tabView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: tabView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        view = nsView
    }
}
