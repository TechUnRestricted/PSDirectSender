//
//  SidebarViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 26.06.2022.
//

import Foundation
import Cocoa

fileprivate class FlippedView: NSClipView {
    override var isFlipped: Bool { return true }
}

class SidebarViewController: NSViewController {
    //let stackView = NSStackView()
    let stackContainer: NSStackView = {
        let stackContainer = NSStackView()
        stackContainer.orientation = .vertical
        stackContainer.spacing = -5
        stackContainer.alignment = .width
        //stackContainer.wantsLayer = true
        //stackContainer.layer?.backgroundColor = NSColor.systemPink.cgColor
        return stackContainer
    }()
    
    private let stackView = NSStackView()
    override func loadView() {
        let scrollView = NSScrollView()
        view = scrollView
        
        
        stackView.alignment = .centerY
        stackView.orientation = .vertical
        
        stackView.wantsLayer = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        
        //stackView.spacing = 0
        
        let clipView = FlippedView()
        scrollView.contentView = clipView
        
        
        //clipView.drawsBackground = true
        //clipView.backgroundColor = NSColor.systemPink
        scrollView.contentView = clipView
        
        clipView.documentView = stackView
        clipView.addConstraint(NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: clipView, attribute: .left, multiplier: 1.0, constant: 0))
        clipView.addConstraint(NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: clipView, attribute: .right, multiplier: 1.0, constant: 0))
        
        
        let imageView: NSImageView = {
            let imageView = NSImageView()
            imageView.image = NSImage(named: .appIcon)
            imageView.alphaValue = 0.8
            return imageView
        }()
        
        let navigationTextField: NSTextField = {
            let navigationTextField = NSTextField()
            navigationTextField.stringValue = "Navigation"
            navigationTextField.alphaValue = 0.8
            navigationTextField.drawsBackground = false
            navigationTextField.isEditable = false
            navigationTextField.isBezeled = false
            
            return navigationTextField
        }()
        
        stackView.addView(imageView, in: .top)
        stackView.addView(stackContainer, in: .top)
        
        stackView.addConstraint(NSLayoutConstraint(item: stackContainer, attribute: .left, relatedBy: .equal, toItem: stackView, attribute: .left, multiplier: 1.0, constant: 0))
        stackView.addConstraint(NSLayoutConstraint(item: stackContainer, attribute: .right, relatedBy: .equal, toItem: stackView, attribute: .right, multiplier: 1.0, constant: 0))
        
        stackContainer.addView(navigationTextField, in: .top)
        stackContainer.addConstraint(NSLayoutConstraint(item: navigationTextField, attribute: .left, relatedBy: .equal, toItem: stackContainer, attribute: .left, multiplier: 1.0, constant: 15))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
