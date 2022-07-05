//
//  InfoViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.06.2022.
//

import Foundation
import Cocoa

class InfoViewController: NSViewController {
    
    init() {
        print("Initialized \(#function): \(arc4random())")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nsView = NSView()
    
    override func loadView() {

        //nsView.wantsLayer = true
        //nsView.layer?.backgroundColor = NSColor.yellow.cgColor
        
        let mainContainerView: NSStackView = {
            let element = NSStackView()
            element.orientation = .vertical
            //element.wantsLayer = true
            //element.layer?.backgroundColor = NSColor.red.cgColor
            element.translatesAutoresizingMaskIntoConstraints = false
            
            return element
        }()
        nsView.addSubview(mainContainerView)
        
        nsView.addConstraint(NSLayoutConstraint(item: mainContainerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 400))
        nsView.addConstraint(NSLayoutConstraint(item: mainContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280))
        
        nsView.addConstraint(NSLayoutConstraint(item: mainContainerView, attribute: .centerX, relatedBy: .equal, toItem: nsView, attribute: .centerX, multiplier: 1.0, constant: 0))
        nsView.addConstraint(NSLayoutConstraint(item: mainContainerView, attribute: .centerY, relatedBy: .equal, toItem: nsView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        let imageAndTextContainer: NSStackView = {
            let horizontalStack = NSStackView()
            horizontalStack.orientation = .horizontal
            
            let imageView: NSImageView = {
                let imageView = NSImageView()
                imageView.image = NSImage(named: .appIcon)
                imageView.setDimensions(width: 80, height: 80)
                return imageView
            }()
            horizontalStack.addArrangedSubview(imageView)
            
            let verticalStack: NSStackView = {
                let verticalStack = NSStackView()
                verticalStack.orientation = .vertical
                verticalStack.spacing = 0
                verticalStack.alignment = .leading
                
                let appTitle: NSTextField = {
                    let textField = NSTextField()
                    textField.stringValue = Bundle.main.appName
                    textField.font = .systemFont(ofSize: 22, weight: .regular)
                    textField.alphaValue = 0.9
                    textField.drawsBackground = false
                    textField.isEditable = false
                    textField.isBezeled = false
                    return textField
                }()
                verticalStack.addArrangedSubview(appTitle)
                
                let appSubtitle: NSTextField = {
                    let textField = NSTextField()
                    textField.stringValue = "for Remote Package Installer"
                    textField.font = .systemFont(ofSize: 14, weight: .regular)
                    textField.alphaValue = 0.6
                    textField.drawsBackground = false
                    textField.isEditable = false
                    textField.isBezeled = false
                    return textField
                }()
                verticalStack.addArrangedSubview(appSubtitle)
                
                let appVersion: NSTextField = {
                    let textField = NSTextField()
                    textField.stringValue = "Version: \(Bundle.main.appVersionLong)"
                    textField.font = .systemFont(ofSize: 11, weight: .regular)
                    textField.alphaValue = 0.9
                    textField.drawsBackground = false
                    textField.isEditable = false
                    textField.isBezeled = false
                    return textField
                }()
                verticalStack.addArrangedSubview(appVersion)
                
                return verticalStack
            }()
            
            horizontalStack.addArrangedSubview(verticalStack)
            
            
            return horizontalStack
        }()
        mainContainerView.addArrangedSubview(imageAndTextContainer)
        mainContainerView.setCustomSpacing(25, after: imageAndTextContainer)

        let licenseContainer: NSStackView = {
            let licenseContainer = NSStackView()
            licenseContainer.orientation = .vertical
            licenseContainer.spacing = 10
            licenseContainer.alignment = .leading
            
            let text1: NSTextField = {
                let element = NSTextField()
                element.stringValue = "This software is distributed under the Apache License, Version 2.0."
                element.font = .systemFont(ofSize: 11, weight: .regular)
                element.alphaValue = 0.5
                element.drawsBackground = false
                element.isEditable = false
                element.isBezeled = false
                return element
            }()
            licenseContainer.addArrangedSubview(text1)
            
            let text2: NSTextField = {
                let element = NSTextField()
                element.stringValue = "This software contains a third-party library \"Mongoose - Embedded Web Server\" which is distributed under the GNU General Public License, Version 2.0"
                element.font = .systemFont(ofSize: 11, weight: .regular)
                element.alphaValue = 0.5
                element.drawsBackground = false
                element.isEditable = false
                element.isBezeled = false
                return element
            }()
            licenseContainer.addArrangedSubview(text2)
            
            return licenseContainer
        }()
        mainContainerView.addArrangedSubview(licenseContainer)
        
        //licenseContainer.wantsLayer = true
        //licenseContainer.layer?.backgroundColor = NSColor.purple.cgColor
        mainContainerView.setCustomSpacing(25, after: licenseContainer)
        let inlineButtonsContainer: NSStackView = {
            let inlineButtonsContainer = NSStackView()
            inlineButtonsContainer.orientation = .vertical
            inlineButtonsContainer.spacing = 10
            //inlineButtonsContainer.alignment = .centerX
            
            let linkButton: NSButton = {
                let linkButton = NSButton()
                linkButton.attributedTitle = NSAttributedString(string: "View Source Code on GitHub", attributes: [NSAttributedString.Key.foregroundColor: NSColor.systemBlue])
                linkButton.isBordered = false
                
                return linkButton
            }()
            inlineButtonsContainer.addArrangedSubview(linkButton)
            
            let openSourceLicensesButton: NSButton = {
                let linkButton = NSButton()
                linkButton.attributedTitle = NSAttributedString(string: "View Open Source Licenses", attributes: [NSAttributedString.Key.foregroundColor: NSColor.systemBlue])
                linkButton.isBordered = false
                
                return linkButton
            }()
            inlineButtonsContainer.addArrangedSubview(openSourceLicensesButton)
            
            return inlineButtonsContainer
        }()
        
        mainContainerView.addArrangedSubview(inlineButtonsContainer)
        
        
        view = nsView
        view.addConstraint(NSLayoutConstraint(item: nsView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 470))
        view.addConstraint(NSLayoutConstraint(item: nsView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 450))
    }
}
