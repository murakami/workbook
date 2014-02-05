//
//  MyScene.m
//  Spiritus
//
//  Created by 村上幸雄 on 2014/01/13.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "SpaceshipScene.h"
#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    DBGMSG(@"%s", __func__);
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.name = @"myLabel";  /* ノードに名前を付ける */
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:myLabel];
    }
    return self;
}

- (void)willMoveFromView:(SKView *)view
{
    DBGMSG(@"%s", __func__);
}

- (void)didMoveToView:(SKView *)view
{
    DBGMSG(@"%s", __func__);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *myLabel = [self childNodeWithName:@"myLabel"];  /* ノードを取得する */
    if (myLabel != nil) {
        myLabel.name = nil;
        SKAction    *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5]; /* 上昇 */
        SKAction    *zoom = [SKAction scaleTo: 2.0 duration: 0.25];         /* 拡大 */
        SKAction    *pause = [SKAction waitForDuration: 0.5];               /* 停止 */
        SKAction    *fadeAway = [SKAction fadeOutWithDuration: 0.25];       /* フェードアウト */
        SKAction    *remove = [SKAction removeFromParent];                  /* 消滅 */
        SKAction    *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [myLabel runAction:moveSequence completion:^{
            /* SpaceshipSceneに遷移 */
            SKScene *spaceshipScene  = [[SpaceshipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
}

@end
