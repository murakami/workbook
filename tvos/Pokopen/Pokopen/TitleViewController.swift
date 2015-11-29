//
//  TitleViewController.swift
//  Pokopen
//
//  Created by 村上幸雄 on 2015/11/29.
//  Copyright © 2015年 MURAKAMI Yukio. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    var containerViewController: ContainerViewController?
    
    override func viewDidLoad() {
        print("TitleViewController # viewDidLoad()")
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func optionButtonTapped(_: AnyObject) {
        print("option button tapped.")
    }
    
    @IBAction func startButtonTapped(_: AnyObject) {
        print("start button tapped.")
        containerViewController!.toGameViewController()
    }
}

/* End Of File */