//
//  MyViewController.m
//  TransitionView
//
//  Created by 村上 幸雄 on 12/09/29.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()
- (void)_init;
@end

@implementation MyViewController

/*
- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}
*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
}

- (void)dealloc
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
}

- (void)loadView
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super loadView];
}

- (void)viewDidLoad
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    DBGMSG(@"%s, title:%@", __func__, self.title);
    [super didReceiveMemoryWarning];
}

@end
