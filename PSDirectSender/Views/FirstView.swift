//
//  FirstView.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Foundation
import Cocoa



class FirstView: NSViewController {
    
    
    override func loadView() {
        
        let backgroundView = NSView()
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = NSColor.purple.cgColor
        view = backgroundView
        
        let nsView = NSStackView()
        nsView.wantsLayer = true
        nsView.layer?.backgroundColor = NSColor.cyan.cgColor
        nsView.alignment = .top
        nsView.orientation = .vertical
        nsView.translatesAutoresizingMaskIntoConstraints = false
        
        let secondView = NSProgressIndicator()
        let thirdView = NSTextField()
        thirdView.stringValue = "-"
        let fourth = NSTextField()
        fourth.stringValue = "+"
        
        let imageView1: NSImageView = {
            let icon = NSImage(named: .queue)
            let imageViewObject = NSImageView()
            imageViewObject.image = icon
            return imageViewObject
        }()
        
        let imageView2: NSImageView = {
            let icon = NSImage(named: .configuration)
            let imageViewObject = NSImageView()
            imageViewObject.image = icon
            return imageViewObject
        }()
        
        let imageView3: NSImageView = {
            let icon = NSImage(named: .logs)
            let imageViewObject = NSImageView()
            imageViewObject.image = icon
            return imageViewObject
        }()
        
        let imageView4: NSImageView = {
            let icon = NSImage(named: .info)
            let imageViewObject = NSImageView()
            imageViewObject.image = icon
            return imageViewObject
        }()
        
        let customTextField: NSTextField = {
            let test = NSTextField()
            
            let text = CustomTextFieldCell()
            text.stringValue = "Text"
            
            test.cell = text
           
            
            return test
        }()
        
        nsView.addView(secondView, in: .top)
        nsView.addView(thirdView, in: .top)
        nsView.addView(fourth, in: .top)
        nsView.addView(imageView1, in: .top)
        nsView.addView(imageView2, in: .top)
        nsView.addView(imageView3, in: .top)
        nsView.addView(imageView4, in: .top)
        nsView.addView(customTextField, in: .top)
        
        backgroundView.addSubview(nsView)
        
        backgroundView.addConstraint(
            NSLayoutConstraint(
                item: nsView,
                attribute: .top,
                relatedBy: .equal,
                toItem: backgroundView,
                attribute: .top,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        backgroundView.addConstraint(
            NSLayoutConstraint(
                item: nsView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: backgroundView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        backgroundView.addConstraint(
            NSLayoutConstraint(
                item: nsView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: backgroundView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        //imageViewObject.setContentCompressionResistancePriority(.dragThatCannotResizeWindow, for: .horizontal)
        
        // view = nsView
        
        /*
         
         
         view.addSubview(nsView)
         
         view.addConstraint(
         NSLayoutConstraint(
         item: nsView,
         attribute: .top,
         relatedBy: .equal,
         toItem: view,
         attribute: .top,
         multiplier: 1.0,
         constant: 0
         )
         )
         
         view.addConstraint(
         NSLayoutConstraint(
         item: nsView,
         attribute: .leading,
         relatedBy: .equal,
         toItem: view,
         attribute: .leading,
         multiplier: 1.0,
         constant: 0
         )
         )
         
         view.addConstraint(
         NSLayoutConstraint(
         item: nsView,
         attribute: .trailing,
         relatedBy: .equal,
         toItem: view,
         attribute: .trailing,
         multiplier: 1.0,
         constant: 0
         )
         )
         
         view.addConstraint(
         NSLayoutConstraint(
         item: nsView,
         attribute: .bottom,
         relatedBy: .equal,
         toItem: view,
         attribute: .bottom,
         multiplier: 1.0,
         constant: 0
         )
         )
         */
        
        
        /*let logoIcon = NSImage(named: .logo)
         let imageViewObject = NSImageView(frame: NSRect(origin: .zero, size: logoIcon!.size))
         view = imageViewObject*/
    }
}
