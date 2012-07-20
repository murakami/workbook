//
//  ViewController.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameController.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize gameController = _gameController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.gameController = [[GameController alloc] initWithView:(GameBoardView *)self.view];
}

- (void)viewDidUnload
{
    self.gameController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
