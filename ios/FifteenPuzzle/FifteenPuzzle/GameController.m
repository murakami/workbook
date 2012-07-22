//
//  GameController.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameController.h"

@interface GameController ()
@property(nonatomic, weak) GamePieceView    *pieceView;
@property(nonatomic, assign) CGPoint        startLocation;
@end

@implementation GameController

@synthesize gameBoardView = _gameBoardView;
@synthesize pieceView = _pieceView;
@synthesize startLocation = _startLocation;

- (id)initWithView:(GameBoardView *)view
{
    self = [super init];
    if (self) {
        self.gameBoardView = view;
        [self.gameBoardView setupWithDelegate:self];
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
    GameSquare      *square = [self.gameBoardView squareAtPoint:touchPt];
    GamePieceView   *pieceView = [self.gameBoardView pieceViewAtPoint:touchPt];
    NSLog(@"square(%d)", square.index);
    NSLog(@"pieceView: %@", pieceView);
    if (pieceView) {
        //DBGMSG(@"%s", __func__);
        self.pieceView = pieceView;
        self.startLocation = touchPt;
    }
}

- (void)gameBoardViewTouchMove:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
    if (self.pieceView) {
        //DBGMSG(@"%s", __func__);
        CGRect  frame = [self.pieceView frame];
        frame.origin.x += touchPt.x - self.startLocation.x;
        frame.origin.y += touchPt.y - self.startLocation.y;
        self.startLocation = touchPt;
        [self.pieceView setFrame:frame];
    }
}

- (void)gameBoardViewTouchUp:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
    if (self.pieceView) {
        GameSquare      *square = [self.gameBoardView squareAtPoint:touchPt];
        [self.pieceView moveWithSquare:square];
    }
    self.pieceView = nil;
}

@end
