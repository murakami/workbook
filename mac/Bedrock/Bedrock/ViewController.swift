//
//  ViewController.swift
//  Bedrock
//
//  Created by 村上幸雄 on 2018/02/27.
//  Copyright © 2018年 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let exam = Exam()
        exam.dbgmsg()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

