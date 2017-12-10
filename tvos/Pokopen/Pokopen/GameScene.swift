//
//  GameScene.swift
//  Pokopen
//
//  Created by 村上幸雄 on 2015/11/29.
//  Copyright (c) 2015年 MURAKAMI Yukio. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotate(byAngle: CGFloat.pi, duration:1)
            
            sprite.run(SKAction.repeatForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
