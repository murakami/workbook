//
//  DataViewController.m
//  Books
//
//  Created by 村上 幸雄 on 12/04/07.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "AppDelegate.h"
#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

@synthesize dataLabel = _dataLabel;
@synthesize dataObject = _dataObject;
@synthesize document = _document;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate	*appl = nil;
	appl = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.document = appl.document;
}

- (void)viewDidUnload
{
    self.document = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.dataLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
