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
    
    override func loadView() {
        let mainStackContainer = NSStackView()
    
        view = mainStackContainer
    }
}
