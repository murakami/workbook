//
//  SpaceshipScene.m
//  Spiritus
//
//  Created by 村上幸雄 on 2014/02/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "SpaceshipScene.h"

static inline CGFloat skRandf(void)
{
    DBGMSG(@"%s", __func__);
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    DBGMSG(@"%s", __func__);
    return skRandf() * (high - low) + low;
}

@interface SpaceshipScene ()
@property (assign, nonatomic) BOOL  contentCreated;
@end

@implementation SpaceshipScene

@synthesize contentCreated = _contentCreated;

-(id)initWithSize:(CGSize)size
{
    DBGMSG(@"%s", __func__);
    if (self = [super initWithSize:size]) {
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
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    DBGMSG(@"%s", __func__);
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    /* 宇宙船を配置 */
    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150);
    [self addChild:spaceship];
    
    /* 岩石を作り出す */
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.10 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
}

- (SKSpriteNode *)newSpaceship
{
    DBGMSG(@"%s", __func__);
    /* 宇宙船を生成 */
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64,32)];
    
    NSMutableArray  *textureArray = [[NSMutableArray alloc] init];
#if 0
    for (int i = 1; i <= 10; i++) {
        NSString    *filename = [NSString stringWithFormat:@"spaceship%02d", i];
        SKTexture   *texture = [SKTexture textureWithImageNamed:filename];
        [textureArray addObject:texture];
    }
#else
    SKTextureAtlas  *spaceshipTextureAtlas = [SKTextureAtlas atlasNamed:@"spaceship"];
    for (int i = 1; i <= 10; i++) {
        NSString    *filename = [NSString stringWithFormat:@"spaceship%02d", i];
        SKTexture   *texture = [spaceshipTextureAtlas textureNamed:filename];
        [textureArray addObject:texture];
    }
#endif
    SKAction    *animationAction = [SKAction animateWithTextures:textureArray timePerFrame:0.1];
    [hull runAction:[SKAction repeatActionForever:animationAction]];
    
    /* 宇宙船にライトをつける */
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    /* 宇宙船にライトをつける */
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    /* 宇宙船に実体を与える */
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    
    /* 宇宙船に重力の影響が与えられないようにする */
    hull.physicsBody.dynamic = NO;
    
    /* 宇宙船を動かす */
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:-50 duration:1.0]]];
    [hull runAction: [SKAction repeatActionForever:hover]];
    
    return hull;
}

- (SKSpriteNode *)newLight
{
    DBGMSG(@"%s", __func__);
    /* ライトを生成 */
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    /* 点滅させる */
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}

- (void)addRock
{
    DBGMSG(@"%s", __func__);
    
    /* 岩石を作り出す */
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8,8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;   /* 衝突判定を正確に */
    [self addChild:rock];
}

-(void)didSimulatePhysics
{
    DBGMSG(@"%s", __func__);
    
    /* 物理シミュレート後の実行 */
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        /* 見えなくなった岩石を削除 */
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

@end
