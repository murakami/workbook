//
//  Game.swift
//  Pokopen
//
//  Created by 村上幸雄 on 2015/12/23.
//  Copyright © 2015年 MURAKAMI Yukio. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Game {
    var gameScene: GameScene?
    let random: GKRandomSource?
    
    init() {
        random = GKRandomSource()
    }
    
    deinit {
    }
    
    var scene: GameScene? {
        get {
            if gameScene == nil {
                gameScene = GameScene(fileNamed: "GameScene")
            }
            return gameScene
        }
    }
}