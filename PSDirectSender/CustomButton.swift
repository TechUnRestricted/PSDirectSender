//
//  CustomButton.swift
//  PSDirectSender
//
//  Created by Macintosh on 01.07.2022.
//

import Cocoa

class CustomButton: NSStackView {
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        configure()
    }
    
    override func mouseDown(with event: NSEvent) {
        /* */
    }
    
    override func mouseUp(with event: NSEvent) {
        /* */
    }
    
    func configure() {
        self.orientation = .horizontal // !!!
        self.alignment = .centerX      // !!!
        
        let imageView: NSImageView = {
            let element = NSImageView()
            element.image = NSImage(named: .configuration)
            element.alphaValue = 0.8
            element.setDimensions(width: 20, height: 20)

            element.wantsLayer = true
            element.layer?.backgroundColor = NSColor.systemPink.cgColor
                        
            return element
        }()
        
        let textField: NSTextField = {
            let element = NSTextField()
            element.stringValue = "macOS"
            element.isBezeled = false
            element.drawsBackground = false
            element.isEditable = false
            
            element.wantsLayer = true
            element.layer?.backgroundColor = NSColor.cyan.cgColor
            
            return element
        }()
        
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(textField)
        
        /* */
    }
    
}

