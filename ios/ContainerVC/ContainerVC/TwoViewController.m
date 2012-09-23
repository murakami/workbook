//
//  TwoViewController.m
//  ContainerVC
//
//  Created by 村上 幸雄 on 12/09/23.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "CVCViewController.h"
#import "TwoViewController.h"

@interface TwoViewController ()
@end

@implementation TwoViewController

@synthesize cvcViewController = _cvcViewController;

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
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    DBGMSG(@"%s", __func__);
    self.cvcViewController = nil;
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

- (IBAction)toggleVC:(id)sender
{
    DBGMSG(@"%s", __func__);
    [self.cvcViewController toggleVC];
}

@end
