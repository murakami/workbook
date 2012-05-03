//
//  ViewController.m
//  Hyperlinks
//
//  Created by 村上 幸雄 on 12/05/03.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize textView = _textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.textView.editable = NO;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.text = @"This is a demonstration.\nhttp://www.bitz.co.jp/\nThank you.";
}

- (void)viewDidUnload
{
    self.textView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
