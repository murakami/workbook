//
//  GameViewController.swift
//  Pokopen
//
//  Created by 村上幸雄 on 2015/11/23.
//  Copyright (c) 2015年 MURAKAMI Yukio. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var containerViewController: ContainerViewController?
    var game: Game?

    override func viewDidLoad() {
        print(NSStringFromClass(self.dynamicType), __FUNCTION__)
        super.viewDidLoad()
        
        game = Game()
        if let aGame = game {
            let scene = aGame.scene
            scene!.scaleMode = .AspectFill
            
            let skView = view as! SKView
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
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
        // Release any cached data, images, etc that aren't in use.
    }
}
