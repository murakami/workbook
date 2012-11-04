//
//  CVCViewController.m
//  ContainerVC
//
//  Created by 村上 幸雄 on 12/09/23.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OneViewController.h"
#import "TwoViewController.h"
#import "CVCViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface CVCViewController ()
@property (nonatomic, weak) UIViewController    *selectedViewController;
@end

@implementation CVCViewController

@synthesize selectedViewController = _selectedViewController;

- (void)viewDidLoad
{
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    /* 子ビューコントローラを取得 */
    UIStoryboard    *oneStoryboard = [UIStoryboard storyboardWithName:@"OneStoryboard" bundle:nil];
    UIStoryboard    *twoStoryboard = [UIStoryboard storyboardWithName:@"TwoStoryboard" bundle:nil];
    OneViewController   *oneViewController = [oneStoryboard instantiateInitialViewController];
    TwoViewController   *twoViewController = [twoStoryboard instantiateInitialViewController];
    
    UIStoryboard    *ncOneStoryboard = [UIStoryboard storyboardWithName:@"NCOneStoryboard" bundle:nil];
    UIStoryboard    *ncTwoStoryboard = [UIStoryboard storyboardWithName:@"NCOneStoryboard" bundle:nil];
    UINavigationController  *ncOneViewController = [ncOneStoryboard instantiateInitialViewController];
    UINavigationController  *ncTwoViewController = [ncTwoStoryboard instantiateInitialViewController];

    /* コンテナViewControllerの子ViewControllerに登録 */
    [self addChildViewController:oneViewController];
    [self addChildViewController:twoViewController];
    oneViewController.cvcViewController = self;
    twoViewController.cvcViewController = self;

    [self addChildViewController:ncOneViewController];
    [self addChildViewController:ncTwoViewController];
    ncOneViewController.title = @"NCOne";
    ncTwoViewController.title = @"NCTwo";
    ((MasterViewController *)ncOneViewController.topViewController).cvcViewController = self;
    ((MasterViewController *)ncTwoViewController.topViewController).cvcViewController = self;

    /* 強制的に呼ぶ */
    [oneViewController didMoveToParentViewController:self];
    [twoViewController didMoveToParentViewController:self];
    
    /* 最初の画面を設定 */
    /*
    self.selectedViewController = [self.childViewControllers objectAtIndex:0];
    CGRect  frame = self.selectedViewController.view.frame;
    frame.origin = CGPointMake(0.0, 0.0);
    self.selectedViewController.view.frame = frame;
    [self.view addSubview:self.selectedViewController.view];
    */
    
    self.selectedViewController = ncOneViewController;
    CGRect  frame = self.selectedViewController.view.frame;
    frame.origin = CGPointMake(0.0, 0.0);
    self.selectedViewController.view.frame = frame;
    [self.view addSubview:self.selectedViewController.view];
}

- (void)viewDidUnload
{
    DBGMSG(@"%s", __func__);
    self.selectedViewController = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    DBGMSG(@"%s", __func__);
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    DBGMSG(@"%s", __func__);
    [super didMoveToParentViewController:parent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageScreenShot:(UIViewController *)viewController
{
    UIGraphicsBeginImageContextWithOptions(viewController.view.frame.size, 1.0, 0.0);
    [viewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)toggleVC
{
    DBGMSG(@"%s", __func__);
#if 0
    UIViewController    *oneViewController = [self.childViewControllers objectAtIndex:0];
    UIViewController    *twoViewController = [self.childViewControllers objectAtIndex:1];
#endif
    UINavigationController  *ncOneViewController = [self.childViewControllers objectAtIndex:2];
    UINavigationController  *ncTwoViewController = [self.childViewControllers objectAtIndex:3];
#if 0
    if (self.selectedViewController == oneViewController) {
        [self transitionFromViewController:oneViewController
                          toViewController:twoViewController
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:NULL
                                completion:NULL];
        self.selectedViewController = twoViewController;
    }
    else {
        [UIView animateWithDuration:1.0
                         animations:^{
                             CGPoint fromPt = twoViewController.view.layer.position;
                             CGPoint toPt = CGPointMake(fromPt.x, (fromPt.y * -1.0));
                             twoViewController.view.layer.position = toPt;
                         }
                         completion:^(BOOL finished) {
                             /* 元の位置の戻す */
                             CGPoint fromPt = twoViewController.view.layer.position;
                             CGPoint toPt = CGPointMake(fromPt.x, (fromPt.y * -1.0));
                             twoViewController.view.layer.position = toPt;
                             
                             /* 画面遷移（アニメーションなし） */
                             [self transitionFromViewController:twoViewController
                                               toViewController:oneViewController
                                                       duration:0.0
                                                        options:0
                                                     animations:NULL
                                                     completion:NULL];
                         }];
        self.selectedViewController = oneViewController;
    }
#endif
    if ([self.selectedViewController.title compare:@"NCOne"] == NSOrderedSame) {
        [self transitionFromViewController:ncOneViewController
                          toViewController:ncTwoViewController
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^ {
                                    /*
                                    UIImage *oneImage = [self imageScreenShot:ncOneViewController.visibleViewController];
                                    UIImage *twoImage = [self imageScreenShot:ncTwoViewController.visibleViewController];
                                    ncOneViewController.visibleViewController.view.layer.contents = twoImage;
                                    CALayer *layer = [CALayer layer];
                                    layer.contents = oneImage;
                                    [ncOneViewController.visibleViewController.view.layer addSublayer:layer];
                                    CATransition    *theAnimation = [CATransition animation];
                                    theAnimation.type = kCATransitionFade;
                                    theAnimation.subtype = kCATransitionFromBottom;
                                    theAnimation.delegate = self;
                                    [ncOneViewController.visibleViewController.view.layer addAnimation:theAnimation forKey:nil];
                                    */
           
                                    /*
                                    [UIView beginAnimations:@"flip view" context:nil];
                                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                                           forView:ncTwoViewController.visibleViewController.view
                                                             cache:YES];
                                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                    [UIView setAnimationDuration:1.0];
                                    [UIView commitAnimations];
                                    */
                                }
                                completion:^(BOOL finished) {
                                    /*
                                    for (CALayer *layer in ncOneViewController.visibleViewController.view.layer.sublayers) {
                                        layer.contents = nil;
                                        [layer removeFromSuperlayer];
                                    }
                                    ncOneViewController.visibleViewController.view.layer.contents = nil;
                                    */
                                    //[ncOneViewController popToRootViewControllerAnimated:NO];
                                    self.selectedViewController = ncTwoViewController;
                                }];
        //[ncOneViewController popToRootViewControllerAnimated:NO];
        //self.selectedViewController = ncTwoViewController;
    }
    else {
        [self transitionFromViewController:ncTwoViewController
                          toViewController:ncOneViewController
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^ {
                                    
                                }
                                completion:^(BOOL finished) {
                                    //[ncTwoViewController popToRootViewControllerAnimated:NO];
                                    self.selectedViewController = ncOneViewController;
                                }];
        //[ncTwoViewController popToRootViewControllerAnimated:NO];
        //self.selectedViewController = ncOneViewController;
    }
}

@end
