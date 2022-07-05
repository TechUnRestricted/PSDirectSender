//
//  SplitViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Foundation
import Cocoa

//@available(macOS 10.10, *)
class SplitViewController: NSSplitViewController, TableViewDelegate {
    //var selectedScreen: SelectedScreen = .queue
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    lazy var tableView: TableViewController = {
        let tableView = TableViewController()
        tableView.delegate = self
        return tableView
    }()
    
    lazy var sidebar: SidebarViewController = {
        var parent = SidebarViewController()
        
        parent.stackContainer.addView(tableView.view, in: .bottom)
        
        
        return parent
    }()
    
    lazy var content = ContentViewController()
    
    func changeIndexOfSelectedTab(_ index: Int) {
        content.changeTab(index: index)
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        
        view.wantsLayer = true
        
        splitView.dividerStyle = .thin
        
        splitView.identifier = NSUserInterfaceItemIdentifier(rawValue: UUID().uuidString)
    }
    
    private func setupLayout() {
        addSplitViewItem(NSSplitViewItem(sidebarWithViewController: sidebar))
        addSplitViewItem(NSSplitViewItem(viewController: content))
    }
}
