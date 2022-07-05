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

    @objc func continueButtonClicked(_ sender: NSButton) {
        print("Continue button clicked")
    }
    let nsView = NSView()

    override func loadView() {
    
        view = nsView
        
        view.addConstraint(NSLayoutConstraint(item: nsView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 470))
        view.addConstraint(NSLayoutConstraint(item: nsView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 450))
    }
}
