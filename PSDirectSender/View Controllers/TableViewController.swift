//
//  TableViewController.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Foundation
import Cocoa

struct TableScreen {
    let text: String
    let image: NSImage
}

let tableScreens = [
    TableScreen(text: "Queue", image: NSImage(named: .queue) ?? NSImage()),
    TableScreen(text: "Configuration", image: NSImage(named: .configuration) ?? NSImage()),
    TableScreen(text: "Logs", image: NSImage(named: .logs) ?? NSImage()),
    TableScreen(text: "Info", image: NSImage(named: .info) ?? NSImage()),
    
    TableScreen(text: "Temp", image: NSImage(named: .temp) ?? NSImage()),
    
]

protocol TableViewDelegate: AnyObject {
    func changeIndexOfSelectedTab(_ index: Int)
}

class TableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    weak var delegate: TableViewDelegate?
    
    var initialized = false
    //let scrollView = NSScrollView()
    let tableView = NSTableView()
    
    override func loadView() {
        print("TableView loaded")
        view = tableView
        //view.wantsLayer = true
        //view.layer?.backgroundColor = NSColor.yellow.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayout() {
        if !initialized {
            initialized = true
            setupView()
            setupTableView()
            tableView.selectRowIndexes(NSIndexSet(index: 1) as IndexSet, byExtendingSelection: false)
        }
    }
    
    func setupView() {
        //view.translatesAutoresizingMaskIntoConstraints = false
        //view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
    }
    
    func setupTableView() {
        
        
       // tableView.frame = scrollView.bounds*/
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.rowHeight = 35
        tableView.allowsMultipleSelection = false
        /*scrollView.backgroundColor = NSColor.clear
        scrollView.drawsBackground = false*/
        tableView.backgroundColor = NSColor.clear
        
        let col = NSTableColumn()
        tableView.addTableColumn(col)
        
        //tableView.wantsLayer = true
        //tableView.layer?.backgroundColor = NSColor.orange.cgColor
        
        /*scrollView.documentView = tableView
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true*/
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("number of rows: \(tableScreens.count)")
        return tableScreens.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let myTable = notification.object as? NSTableView {
            print("Selected row:" ,myTable.selectedRow)
            delegate?.changeIndexOfSelectedTab(myTable.selectedRow)
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let currentScreenProperty = tableScreens[optional: row] else {
            return NSView()
        }
        
        let nsView: NSView = {
           let nsView = NSView()
            nsView.wantsLayer = true
           // nsView.layer?.backgroundColor = NSColor.green.cgColor
            return nsView
        }()
        
        let imageContainer: NSView = {
            let imageContainer = NSView()
            imageContainer.translatesAutoresizingMaskIntoConstraints = false
            imageContainer.wantsLayer = true
            //imageContainer.layer?.backgroundColor = NSColor.brown.cgColor
            
            let imageView: NSImageView = {
                let imageViewObject = NSImageView()
                imageViewObject.image = currentScreenProperty.image
                imageViewObject.translatesAutoresizingMaskIntoConstraints = false
                
                return imageViewObject
            }()
            imageContainer.addSubview(imageView)
            
            let sizeConstant: CGFloat = 8
            
            imageContainer.addConstraint(
                NSLayoutConstraint(
                    item: imageView,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: imageContainer,
                    attribute: .top,
                    multiplier: 1,
                    constant: +sizeConstant
                )
            )
            
            imageContainer.addConstraint(
                NSLayoutConstraint(
                    item: imageView,
                    attribute: .leading,
                    relatedBy: .equal,
                    toItem: imageContainer,
                    attribute: .leading,
                    multiplier: 1,
                    constant: +sizeConstant
                )
            )
            
            imageContainer.addConstraint(
                NSLayoutConstraint(
                    item: imageView,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: imageContainer,
                    attribute: .trailing,
                    multiplier: 1,
                    constant: -sizeConstant
                )
            )
            
            imageContainer.addConstraint(
                NSLayoutConstraint(
                    item: imageView,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: imageContainer,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: -sizeConstant
                )
            )

            
            return imageContainer
        }()
        
        
        
        nsView.addSubview(imageContainer)

        nsView.addConstraint(
            NSLayoutConstraint(
                item: imageContainer,
                attribute: .top,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .top,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: imageContainer,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            )
        )
        

        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: imageContainer,
                attribute: .leading,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: imageContainer,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 30
            )
        )
        
        let anotherTextView: NSTextField = {
            let anotherTextView = NSTextField()
            //anotherTextView.cell = CustomTextFieldCell()
            anotherTextView.stringValue = currentScreenProperty.text
            anotherTextView.isEditable = false
            //anotherTextView.backgroundColor = NSColor.systemPink
            //anotherTextView.alignment = .center
            anotherTextView.drawsBackground = false
            anotherTextView.isBordered = false
            anotherTextView.translatesAutoresizingMaskIntoConstraints = false
           // anotherTextView.wantsLayer = true
           // anotherTextView.layer?.backgroundColor = NSColor.yellow.cgColor
            
            return anotherTextView
        }()
        
        nsView.addSubview(anotherTextView)
        
        
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: anotherTextView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: anotherTextView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: imageContainer,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            )
        )
        
 
        
        nsView.addConstraint(
            NSLayoutConstraint(
                item: anotherTextView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: nsView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0
            )
        )
        
        //nsView.addSubview(anotherTextView, positioned: .out, relativeTo: textField)
        
        return nsView
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NSTableRowView()
        rowView.isEmphasized = false
        return rowView
    }
}
