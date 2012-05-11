//
//  LayerViewController.m
//  CoreAnimation
//
//  Created by 村上 幸雄 on 12/05/11.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "LayerViewController.h"

@interface LayerViewController ()

@end

@implementation LayerViewController

@synthesize backgroundImage = _backgroundImage;
@synthesize frontImage = _frontImage;
@synthesize rearImage = _rearImage;
@synthesize cardLayer = _cardLayer;
@synthesize frontLayer = _frontLayer;
@synthesize rearLayer = _rearLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    
    /* 背景レイヤに背景画像を設定 */
    self.backgroundImage = [UIImage imageNamed:@"background.png"];
    self.view.layer.contents = (id)self.backgroundImage.CGImage;
    
    /* カードの表と裏の画像を用意 */
    self.frontImage = [UIImage imageNamed:@"front.png"];
    self.rearImage = [UIImage imageNamed:@"rear.png"];
    
    /* 表面レイヤと裏面レイヤを一塊のカードとして扱う為のレイヤ */
    CATransform3D   perspactive = CATransform3DIdentity;
    perspactive.m34 = -1.0 / 100.0; /* 遠近感をつける */
    self.cardLayer = [CALayer layer];
    self.cardLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
    self.cardLayer.position = CGPointMake(100.0, 100.0);
    self.cardLayer.sublayerTransform = perspactive;
    self.cardLayer.name = @"card";
    
    /* 表面レイヤ */
    self.frontLayer = [CALayer layer];
    self.frontLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
    self.frontLayer.position = CGPointMake(50.0, 50.0);
    self.frontLayer.contents = (id)self.frontImage.CGImage;
    self.frontLayer.zPosition = 1; /* 表面レイヤを手前に配置 */
    self.frontLayer.name = @"front";
    
    /* 裏面レイヤ */
    self.rearLayer = [CALayer layer];
    self.rearLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
    self.rearLayer.position = CGPointMake(50.0, 50.0);
    self.rearLayer.contents = (id)self.rearImage.CGImage;
    self.rearLayer.zPosition = 0;
    self.rearLayer.transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0); /* 裏返す */
    self.rearLayer.name = @"rear";
    
    /* 表面レイヤと裏面レイヤをカード・レイヤのサブ・レイヤに設定 */
    [self.cardLayer addSublayer:self.frontLayer];
    [self.cardLayer addSublayer:self.rearLayer];
    
    /* カード・レイヤを背景レイヤのサブ・レイヤに設定 */
    [self.view.layer addSublayer:self.cardLayer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [self.frontLayer removeFromSuperlayer];
    [self.rearLayer removeFromSuperlayer];
    [self.cardLayer removeFromSuperlayer];
    self.frontLayer = nil;
    self.rearLayer = nil;
    self.cardLayer = nil;
    self.frontImage = nil;
    self.rearImage = nil;
    self.view.layer.contents = nil;
    self.backgroundImage = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DBGMSG(@"%s", __func__);
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.view];
    CALayer *layer = [self.view.layer hitTest:position]; /* 触ったレイヤ */
    CALayer *containerLayer = layer.superlayer; /* 親レイヤ */
    
    DBGMSG(@"layer name: %@", layer.name);
    DBGMSG(@"container layer name: %@", containerLayer.name);
    
    /* 親レイヤはカード・レイヤ？ */
    if ([containerLayer.name hasPrefix:@"card"]) {
        DBGMSG(@"container layer is card");
        containerLayer.zPosition = 10;
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        CATransform3D   transform = CATransform3DIdentity;
        transform.m34 = -1.0 / 100.0; /* 遠近感をつける */
        
        /* 表に戻す */
        if ([containerLayer.name hasSuffix:@"flipped"]) {
            /* 裏返っていたら、名前の末尾に.flippedがついている */
            transform = CATransform3DRotate(transform, 0.0, 0.0, 1.0, 0.0);
            containerLayer.name = [containerLayer.name stringByDeletingPathExtension];
            /* 名前の末尾の.flippedを削る */
        }
        /* 裏返す */
        else {
            transform = CATransform3DRotate(transform, - M_PI, 0.0, 1.0, 0.0);
            containerLayer.name = [containerLayer.name stringByAppendingPathExtension:@"flipped"];
            /* 裏返したら、名前の末尾に.flippedがつける */
        }
        
        containerLayer.sublayerTransform = transform;
        [CATransaction commit];
    }
}

@end
