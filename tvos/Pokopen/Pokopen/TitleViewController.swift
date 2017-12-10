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
        print(NSStringFromClass(type(of: self)), #function)
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(NSStringFromClass(type(of: self)), #function)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(NSStringFromClass(type(of: self)), #function)
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(NSStringFromClass(type(of: self)), #function)
        super.viewDidDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(NSStringFromClass(type(of: self)), #function)
        super.viewDidDisappear(animated)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        print(NSStringFromClass(type(of: self)), #function)
        super.willMove(toParentViewController: parent)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        print(NSStringFromClass(type(of: self)), #function)
        super.didMove(toParentViewController: parent)
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
