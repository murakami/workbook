//
//  ViewController.m
//  SendLINE
//
//  Created by 村上幸雄 on 2014/05/14.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendLINE:(id)sender
{
    NSString *text = [self.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlFormat = nil;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]]) {
        urlFormat = @"line://msg/text/%@";
    }
    else {
        urlFormat = @"http://line.me/R/msg/text/?%@";
    }
    NSString *urlString = [NSString stringWithFormat:urlFormat, text];
    NSLog(@"%s %@", __func__, urlString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
