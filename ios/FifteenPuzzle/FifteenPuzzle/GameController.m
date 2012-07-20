//
//  GameController.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameController.h"

@implementation GameController

@synthesize gameBoardView = _gameBoardView;

- (id)initWithView:(GameBoardView *)view
{
    self = [super init];
    if (self) {
        self.gameBoardView = view;
        [self.gameBoardView setup];
    }
    return self;
}
- (void)dealloc
{
    self.gameBoardView = nil;
    /* [super dealloc]; */
}

- (void)gameBoardViewTouchDown:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
}

- (void)gameBoardViewTouchMove:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
}

- (void)gameBoardViewTouchUp:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
}

@end
