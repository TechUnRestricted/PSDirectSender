//
//  SecondView.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Foundation
import Cocoa

class ConfigurationViewController: NSViewController {
    
    init() {
        print("Initialized \(#function): \(arc4random())")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let mainStackContainer = NSStackView()
        mainStackContainer.orientation = .vertical
        mainStackContainer.wantsLayer = true
        mainStackContainer.layer?.backgroundColor = NSColor.orange.cgColor
        
        let buttonsStack = NSStackView()
        buttonsStack.orientation = .horizontal
        buttonsStack.alignment = .top
        buttonsStack.wantsLayer = true
        buttonsStack.layer?.backgroundColor = NSColor.cyan.cgColor
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 15
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackContainer.addView(buttonsStack, in: .top)
        
        let badConstraint = NSLayoutConstraint(item: buttonsStack,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: mainStackContainer,
                                               attribute: .width,
                                               multiplier: 1,
                                               constant: 0)
        badConstraint.priority = .defaultLow
        
        mainStackContainer.addConstraint(badConstraint)
        
        
        let addButton: FlatButton = {
            let element = FlatButton()
            element.title = "Add"
            element.wantsLayer = true
            element.isBordered = false
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()
        buttonsStack.addView(addButton, in: .top)
        
        let sendButton: FlatButton = {
            let element = FlatButton()
            element.title = "Send"
            element.wantsLayer = true
            element.isBordered = false
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()
        buttonsStack.addView(sendButton, in: .top)
        
        let deleteButton: FlatButton = {
            let element = FlatButton()
            element.title = "Delete"
            element.wantsLayer = true
            element.isBordered = false
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()
        buttonsStack.addView(deleteButton, in: .top)
        
        
        
        
        //buttonsStack.addConstraint(NSLayoutConstraint(item: addButton, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: sendButton, attribute: .leading, multiplier: 1, constant: 0))
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        addButton.addConstraint(NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        
        //buttonsStack.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: buttonsStack, attribute: .trailing, multiplier: 1, constant: 0))
        sendButton.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        sendButton.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        sendButton.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        deleteButton.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        
        let loadingView = NSProgressIndicator()
        mainStackContainer.addView(loadingView, in: .top)
        
        view = mainStackContainer
    }
}
