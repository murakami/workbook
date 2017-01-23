//
//  ViewController.swift
//  RandomApp
//
//  Created by 村上幸雄 on 2017/01/22.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Cocoa
import GameplayKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet var textField: NSTextField?

    @IBAction func generate(sender: NSButton) {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 99) + 1
        textField?.integerValue = randomNumber
    }
    
    @IBAction func seed(sender: NSButton) {
        textField?.stringValue = "Generator seeded"
    }

}

