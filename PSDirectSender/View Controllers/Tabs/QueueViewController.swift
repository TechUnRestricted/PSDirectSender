//
//  QueueViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Foundation
import Cocoa

class QueueViewController: NSViewController {
    
    init() {
        print("Initialized \(#function): \(arc4random())")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func continueButtonClicked(_ sender: NSButton) {
        print("Continue button clicked")
    }
    
    let nsView = NSView()
    
    override func loadView() {
        
        
        //nsView.wantsLayer = true
        //nsView.layer?.backgroundColor = NSColor.orange.cgColor
        
        addButtons()
        
        
        view = nsView
        view.addConstraint(NSLayoutConstraint(item: nsView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 470))
        view.addConstraint(NSLayoutConstraint(item: nsView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 450))
    }
    
    func addButtons() {
        let buttonsStack = NSStackView()
        buttonsStack.orientation = .horizontal
        buttonsStack.alignment = .top
        
        //buttonsStack.wantsLayer = true
        //buttonsStack.layer?.backgroundColor = NSColor.cyan.cgColor
        
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 15
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        nsView.addSubview(buttonsStack)
        
        let buttonsAlignmentConstraint = NSLayoutConstraint(item: buttonsStack, attribute: .width, relatedBy: .equal, toItem: nsView, attribute: .width, multiplier: 1, constant: -60)
        buttonsAlignmentConstraint.priority = .defaultLow

        let buttonsAlignmentTopConstraint = NSLayoutConstraint(item: buttonsStack, attribute: .top, relatedBy: .equal, toItem: nsView, attribute: .top, multiplier: 1, constant: 25)
        let buttonsAlignmentCenterConstraint = NSLayoutConstraint(item: buttonsStack, attribute: .centerX, relatedBy: .equal, toItem: nsView, attribute: .centerX, multiplier: 1, constant: 0)
        
        nsView.addConstraints([buttonsAlignmentConstraint, buttonsAlignmentTopConstraint, buttonsAlignmentCenterConstraint])
        
        let addButton: ColorButtonView = {
            let element = ColorButtonView()
            element.customTitle = "Add"
            element.customImage = NSImage(named: .add) ?? NSImage()
            element.wantsLayer = true
            element.layer?.backgroundColor = NSColor.systemOrange.cgColor
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()
        buttonsStack.addView(addButton, in: .top)
        
        let sendButton: ColorButtonView = {
            let element = ColorButtonView()
            element.customTitle = "Send"
            element.customImage = NSImage(named: .send) ?? NSImage()
            
            element.wantsLayer = true
            element.translatesAutoresizingMaskIntoConstraints = false
            element.layer?.backgroundColor = NSColor.systemGreen.cgColor
            
            return element
        }()
        buttonsStack.addView(sendButton, in: .top)
        
        let deleteButton: ColorButtonView = {
            let element = ColorButtonView()
            element.customTitle = "Delete"
            element.customImage = NSImage(named: .delete) ?? NSImage()
            element.wantsLayer = true
            element.translatesAutoresizingMaskIntoConstraints = false
            element.layer?.backgroundColor = NSColor.systemRed.cgColor
            return element
        }()
        deleteButton.target = self
        deleteButton.action = #selector(ConfigurationViewController.continueButtonClicked(_:))
        
        buttonsStack.addView(deleteButton, in: .top)
        
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        
        sendButton.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        sendButton.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        sendButton.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
    }
}
