//
//  ViewController.m
//  UDP
//
//  Created by 村上幸雄 on 2015/01/18.
//  Copyright (c) 2015年 村上幸雄. All rights reserved.
//

#import "ViewController.h"
#import "UDP.h"

@interface ViewController ()
- (void)runServerOnPort:(NSUInteger)port;
- (void)runClientWithHost:(NSString *)host port:(NSUInteger)port;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender
{
    NSLog(@"%s", __func__);
}

- (void)runServerOnPort:(NSUInteger)port
{
}

- (void)runClientWithHost:(NSString *)host port:(NSUInteger)port
{
}

@end
