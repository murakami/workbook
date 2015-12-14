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
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.viewDidLoad()
        
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        titleViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TitleViewController") as? TitleViewController
        titleViewController!.containerViewController = self
        gameViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameViewController") as? GameViewController
        gameViewController!.containerViewController = self
        
        self.addChildViewController(titleViewController!)
        self.addChildViewController(gameViewController!)
        titleViewController!.didMoveToParentViewController(self)
        gameViewController!.didMoveToParentViewController(self)
        
        selectedViewController = titleViewController
        self.view.addSubview(selectedViewController!.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.viewDidDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.viewDidDisappear(animated)
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.willMoveToParentViewController(parent)
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.didMoveToParentViewController(parent)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func toGameViewController() {
        transitionFromViewController(titleViewController!, toViewController: gameViewController!, duration: 1.0, options: .TransitionCrossDissolve, animations: nil, completion: { (finished: Bool) -> Void in self.selectedViewController = self.gameViewController })
    }
}

/* End Of File */