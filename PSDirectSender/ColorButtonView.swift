//
//  CustomButton.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.06.2022.
//

import Foundation
import Cocoa


@IBDesignable class ColorButtonView: NSButton {
    private let animationDuration: TimeInterval = 0.2
    private let defaultOpacity: Float = 0.8
    private let pressedOpacity: Float = 0.6
    
    var customTitle: String = "" {
        didSet {
            configure()
            print("\(#function) \(customTitle)")
        }
    }
    
    var customImage: NSImage = NSImage() {
        didSet {
            configure()
            print("\(#function) \(customImage)")
        }
    }
        
    override func draw(_ dirtyRect: NSRect) {
        //print("\(#function) \(arc4random())")
        self.highlight(false)
        
        super.draw(dirtyRect)
    }
    
    override func viewDidMoveToSuperview() {
        //print("\(#function) \(arc4random())")
        configure()
        super.viewDidMoveToSuperview()
    }
    
    override func mouseDown(with event: NSEvent) {
        print("\(#function) \(arc4random())")
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            self.animator().layer?.opacity = pressedOpacity
        }
        
        super.mouseDown(with: event)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            self.animator().layer?.opacity = defaultOpacity
        }
    }
    
    func configure() {
        print("\(#function) \(arc4random())")
        

        
        let textField: NSTextField = {
            let element = NSTextField()
            element.stringValue = customTitle
            element.isBezeled = false
            element.drawsBackground = false
            element.isEditable = false
            element.font = .systemFont(ofSize: 14, weight: .regular)
            //element.wantsLayer = true
            //element.layer?.backgroundColor = NSColor.cyan.cgColor
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()
        
        let imageView: NSImageView = {
            //TODO: Fix image-to-text aligning
            
            let element = NSImageView()
            element.image = customImage
            element.alphaValue = 1
            
            let size: CGFloat = 20
            element.setDimensions(width: size, height: size/* - textField.lastBaselineOffsetFromBottom*/)
            
            //element.wantsLayer = true
            //element.layer?.backgroundColor = NSColor.systemYellow.cgColor
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()

        let elementsContaier: NSView = {
            let element = NSView()
            //element.wantsLayer = true
            //element.layer?.backgroundColor = NSColor.purple.cgColor
            element.addSubview(textField)
            element.addSubview(imageView)
            element.translatesAutoresizingMaskIntoConstraints = false
           return element
        }()
        
        self.addSubview(elementsContaier)
        
        elementsContaier.addConstraint(NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1.0, constant: 8))
        
        self.addConstraint(NSLayoutConstraint(item: elementsContaier, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: elementsContaier, attribute: .trailing, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: elementsContaier, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: elementsContaier, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: elementsContaier, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        elementsContaier.addConstraint(NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: elementsContaier, attribute: .bottom, multiplier: 1.0, constant: -1.5))
        
        self.layer?.cornerRadius = 15
        self.layer?.opacity = defaultOpacity
        self.title = ""
        self.isBordered = false
    }
}
