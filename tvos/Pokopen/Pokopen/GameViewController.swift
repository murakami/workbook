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
        print(NSStringFromClass(type(of: self)), #function)
        super.viewDidLoad()
        
        game = Game()
        if let aGame = game {
            let scene = aGame.scene
            scene!.scaleMode = .aspectFill
            
            let skView = view as! SKView
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
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
}
