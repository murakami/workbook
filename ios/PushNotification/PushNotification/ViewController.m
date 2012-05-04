//
//  ViewController.m
//  PushNotification
//
//  Created by 村上 幸雄 on 12/05/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ConnectionViewController.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize receiveNotificationSwitch = _receiveNotificationSwitch;
@synthesize connectionViewController = _connectionViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
