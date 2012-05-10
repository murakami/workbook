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
    if (self.backgroundImage == nil) {
        self.backgroundImage = [UIImage imageNamed:@"background.png"];
        self.view.layer.contents = (id)self.backgroundImage.CGImage;
    }

    if (self.cardLayer == nil) {
        self.frontImage = [UIImage imageNamed:@"front.png"];
        self.rearImage = [UIImage imageNamed:@"rear.png"];
        
        CATransform3D   perspactive = CATransform3DIdentity;
        perspactive.m34 = -1.0 / 100.0;
        self.cardLayer = [CALayer layer];
        self.cardLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
        self.cardLayer.position = CGPointMake(100.0, 100.0);
        self.cardLayer.sublayerTransform = perspactive;
        self.cardLayer.name = @"card";
        
        CALayer *frontLayer = [CALayer layer];
        frontLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
        frontLayer.position = CGPointMake(50.0, 50.0);
        frontLayer.contents = (id)self.frontImage.CGImage;
        frontLayer.zPosition = 1;
        
        CALayer *rearLayer = [CALayer layer];
        rearLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
        rearLayer.position = CGPointMake(50.0, 50.0);
        rearLayer.contents = (id)self.rearImage.CGImage;
        rearLayer.zPosition = 0;
        rearLayer.transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
        
        [self.cardLayer addSublayer:frontLayer];
        [self.cardLayer addSublayer:rearLayer];
        
        [self.view.layer addSublayer:self.cardLayer];
    }
}

/*
- (void)viewWillDisappear:(BOOL)animated
{
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DBGMSG(@"%s", __func__);
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.view];
    CALayer *layer = [self.view.layer hitTest:position];
    CALayer *containerLayer = layer.superlayer;
    if ([containerLayer.name hasPrefix:@"card"]) {
        DBGMSG(@"container layer is card");
        containerLayer.zPosition = 10;
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        CATransform3D   transform = CATransform3DIdentity;
        transform.m34 = -1.0 / 100.0;
        if ([containerLayer.name hasSuffix:@"flipped"]) {
            transform = CATransform3DRotate(transform, 0.0, 0.0, 1.0, 0.0);
            containerLayer.name = [containerLayer.name stringByDeletingPathExtension];
        }
        else {
            transform = CATransform3DRotate(transform, - M_PI, 0.0, 1.0, 0.0);
            containerLayer.name = [containerLayer.name stringByAppendingPathExtension:@"flipped"];
        }
        containerLayer.sublayerTransform = transform;
        [CATransaction commit];
    }
}

@end
