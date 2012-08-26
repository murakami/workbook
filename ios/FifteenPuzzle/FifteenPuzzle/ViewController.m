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

    self.gameController = [[GameController alloc] initWithView:(GameBoardView *)self.view];
}

- (void)viewDidUnload
{
    self.gameController = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ((event.type == UIEventTypeMotion)
        && (motion == UIEventSubtypeMotionShake)) {
        [self.gameController doShake];
    }
}

@end
