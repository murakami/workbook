//
//  ViewController.swift
//  VisiCalc
//
//  Created by 村上幸雄 on 2019/02/22.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    public func numberOfRows(in tableView: NSTableView) -> Int {
        return 64
    }
    
    public func tableView(_ tableView: NSTableView, viewFor
        tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print(#function + " column:" +
            tableColumn!.identifier.rawValue + " row:" + String(row))
        var result: NSTextField? =
            tableView.makeView(withIdentifier:NSUserInterfaceItemIdentifier(rawValue:
                "MyView"), owner: self) as? NSTextField
        if result == nil {
            result = NSTextField(frame: NSZeroRect)
            result?.identifier =
                NSUserInterfaceItemIdentifier(rawValue: "MyView")
        }
        if let view = result {
            print("view:" + view.identifier!.rawValue + " row:" + String(row))
            if let column = tableColumn {
                if column.identifier.rawValue == "TableColumn1" {
                    view.stringValue = "column 01"
                }
                else if column.identifier.rawValue == "TableColumn2" {
                    view.stringValue = "column 02"
                }
            }
        }
        return result
    }
}

