//
//  CustomButton.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.06.2022.
//

import Foundation
import Cocoa

@IBDesignable class FlatButton: NSButton {
    @IBInspectable var bgColor: NSColor = .darkGray
    @IBInspectable var foreColor: NSColor = .orange
    @IBInspectable var highlightColor: NSColor = .black
    @IBInspectable var cornerRadius: CGFloat = 15
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        configure()
    }
    
    func configure() {
        
        if !isHighlighted {
            self.layer?.backgroundColor = bgColor.cgColor
        } else {
            self.layer?.backgroundColor = highlightColor.cgColor
            /*NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.2
                self.animator().alphaValue = 0.5
            } completionHandler: {
                self.animator().alphaValue = 1
            }*/
        }
        
        /*if self.animator().alphaValue == 1 {
         NSAnimationContext.current.duration = 3
         self.animator().alphaValue = 0
         } else {
         NSAnimationContext.current.duration = 3
         self.animator().alphaValue = 1
         }
         */
        let attributedString = NSAttributedString(string: title,
                                                  attributes: [NSAttributedString.Key.foregroundColor: foreColor])
        self.attributedTitle = attributedString
        
        // Set the corner radius.
        self.layer?.cornerRadius = cornerRadius
    }
}
