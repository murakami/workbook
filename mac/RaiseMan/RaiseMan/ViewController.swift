//
//  ViewController.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2017/02/09.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet public weak var tableView: NSTableView!
    @IBOutlet public weak var deleteButton: NSButton!
    
    var myDocument: Document?
    
    override func awakeFromNib() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.myDocument = self.view.window?.windowController?.document as? Document
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(type(of: self).updateUI(notification:)),
                                               name: Document.updateKey,
                                               object: nil)
    }
    
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self, name: Document.updateKey, object: nil)
        super.viewWillDisappear()
    }
    
    @IBAction func newEmployee(sender: AnyObject) {
        self.myDocument?.newEmployee()
    }
    
    @IBAction func deleteEmployee(sender: AnyObject) {
        let row = tableView.selectedRow
        if row != -1 {
            self.myDocument?.deleteEmployee(index: row)
        }
        else {
            NSBeep()
        }
    }
    
    @objc private func updateUI(notification: Notification) {
        tableView.reloadData()
        deleteButton.isEnabled = (1 < (myDocument?.employees.count)!)
    }
    
    /* 行数 */
    func numberOfRows(in tableView: NSTableView) -> Int {
        var count: Int = 0
        if let document = myDocument {
            count = document.employees.count
        }
        return count
    }
    
    /* カラム:行に表示するインスタンスを返す */
    func tableView(_ aTableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any? {
        let identifier = tableColumn?.identifier
        let person = myDocument?.employees[row]
        return person?.value(forKey: identifier!)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        let person = myDocument?.employees[row]
        if let tcol = tableColumn {
            let identifier = tcol.identifier
            if(identifier == "personName") {
                cell.textField?.stringValue = person?.value(forKey: identifier) as! String
            }
            else if(identifier == "expectedRaise") {
                cell.textField?.floatValue = person?.value(forKey: identifier) as! Float
            }
        }
        return cell
    }
    
    /* 入力されたインスタンスを受け取る */
    func tableView(_ aTableView: NSTableView,
                   setObjectValue object: Any?,
                   for tableColumn: NSTableColumn?,
                   row: Int) {
        let identifier = tableColumn?.identifier
        let person = myDocument?.employees[row]
        person?.setValue(object, forKey: identifier!)
    }
}

