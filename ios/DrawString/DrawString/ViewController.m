//
//  ViewController.m
//  DrawString
//
//  Created by 村上 幸雄 on 12/03/06.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize label = _label;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, 200, 50)];
    self.label.font = [UIFont systemFontOfSize:48.0];
    self.label.text = @"UILabel";
    self.label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.label];
}

- (void)viewDidUnload
{
    [self.label removeFromSuperview];
    self.label = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
