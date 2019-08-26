//
//  ViewController.swift
//  Temperature
//
//  Created by 村上幸雄 on 2019/07/20.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func hotter(_ sender: Any?) {
        self.makeItHotter()
    }

    @IBAction func colder(_ sender: Any?) {
        self.makeItColder()
    }
    
    func makeItHotter() {
        var temperature = self.textField.intValue
        temperature = temperature + 10
        self.undoManager?.registerUndo(withTarget: self, handler: {
            vc in
            vc.makeItColder()
        })
        self.textField.intValue = temperature
    }
    
    func makeItColder() {
        var temperature = self.textField.intValue
        temperature = temperature - 10
        self.undoManager?.registerUndo(withTarget: self, handler: {
            vc in
            vc.makeItHotter()
        })
        self.textField.intValue = temperature
    }

}

