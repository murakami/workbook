//
//  ViewController.swift
//  Identifier
//
//  Created by 村上幸雄 on 2017/04/23.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.label.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func get(sender: AnyObject) {
        self.label.text = Identifier.sharedInstance.uuid
    }
    
    @IBAction func reset(sender: AnyObject) {
        Identifier.sharedInstance.reset()
    }
    
    @IBAction func update(sender: AnyObject) {
        let uuidString = NSUUID().uuidString
        Identifier.sharedInstance.update(uuidString: uuidString)
    }

}

