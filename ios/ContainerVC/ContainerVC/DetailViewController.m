//
//  DetailViewController.m
//  ContainerVC
//
//  Created by 村上 幸雄 on 12/10/13.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "CVCViewController.h"
#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize cvcViewController = _cvcViewController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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
