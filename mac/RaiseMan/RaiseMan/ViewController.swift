//
//  ViewController.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2017/02/09.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet public weak var deleteButton: NSButton!
    @IBOutlet public weak var nextButton: NSButton!
    @IBOutlet public weak var previousButton: NSButton!
    @IBOutlet public weak var nameField: NSTextField!
    @IBOutlet public weak var raiseField: NSTextField!
    @IBOutlet public weak var box: NSBox!
    
    var myDocument: Document?
    
    override func awakeFromNib() {
        self.view.window?.initialFirstResponder = self.nameField
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

    @IBAction func nextEmployee(sender: AnyObject) {
        self.myDocument?.nextEmployee(personName: nameField.stringValue, expectedRaise: raiseField.floatValue)
    }
    
    @IBAction func previousEmployee(sender: AnyObject) {
        self.myDocument?.previousEmployee(personName: nameField.stringValue, expectedRaise: raiseField.floatValue)
    }
    
    @IBAction func deleteEmployee(sender: AnyObject) {
        self.myDocument?.deleteEmployee()
    }
    
    @IBAction func newEmployee(sender: AnyObject) {
        self.myDocument?.newEmployee(personName: nameField.stringValue, expectedRaise: raiseField.floatValue)
    }
    
    @objc private func updateUI(notification: Notification) {
        let recordText = "Record \((self.myDocument?.currentIndex)! + 1) of \(self.myDocument?.employees.count)"
        let currentEmployee = self.myDocument?.employees[(self.myDocument?.currentIndex)!]
        nameField.stringValue = (currentEmployee?.personName)!
        raiseField.floatValue = (currentEmployee?.expectedRaise)!
        box.title = recordText
        previousButton.isEnabled = ((self.myDocument?.currentIndex)! > 0)
        nextButton.isEnabled = ((self.myDocument?.currentIndex)! < ((self.myDocument?.employees.count)! - 1))
        deleteButton.isEnabled = ((self.myDocument?.employees.count)! > 1)
    }

}

