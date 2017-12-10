//
//  ContainerViewController.swift
//  Pokopen
//
//  Created by 村上幸雄 on 2015/11/29.
//  Copyright © 2015年 MURAKAMI Yukio. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var selectedViewController: UIViewController?
    var titleViewController: TitleViewController?
    var gameViewController: GameViewController?
    
    override func viewDidLoad() {
        print(NSStringFromClass(type(of: self)), #function)
        super.viewDidLoad()
        
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        titleViewController = mainStoryboard.instantiateViewController(withIdentifier: "TitleViewController") as? TitleViewController
        titleViewController!.containerViewController = self
        gameViewController = mainStoryboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        gameViewController!.containerViewController = self
        
        self.addChildViewController(titleViewController!)
        self.addChildViewController(gameViewController!)
        titleViewController!.didMove(toParentViewController: self)
        gameViewController!.didMove(toParentViewController: self)
        
        selectedViewController = titleViewController
        self.view.addSubview(selectedViewController!.view)
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
    }
    
    func toGameViewController() {
        transition(from: titleViewController!, to: gameViewController!, duration: 1.0, options: .transitionCrossDissolve, animations: nil, completion: { (finished: Bool) -> Void in self.selectedViewController = self.gameViewController })
    }
}

/* End Of File */
