//
//  ViewController.m
//  IPCClient
//
//  Created by 村上 幸雄 on 12/07/29.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize textField = _textField;
@synthesize button = _button;

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

- (IBAction)send:(id)sender
{
    NSURL   *url = [NSURL URLWithString:@"IPCServer.demo://IPCServer.demo?key=value"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        UIPasteboard    *pastedboard = [UIPasteboard pasteboardWithName:@"demo.IPCClient" create:YES];
        pastedboard.persistent = YES;
        [pastedboard setString:self.textField.text];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
