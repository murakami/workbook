//
//  ViewController.swift
//  GettingThingsDone
//
//  Created by 村上幸雄 on 2017/12/16.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Document.sharedInstance.demo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

