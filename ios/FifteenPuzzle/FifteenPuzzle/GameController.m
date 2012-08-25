//
//  GameController.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameController.h"

@interface GameController ()
@property(nonatomic, weak) GameSquare       *square;
@property(nonatomic, weak) GamePieceView    *pieceView;
@property(nonatomic, assign) CGPoint        startLocation;
- (void)checkGameClear;
@end

@implementation GameController

@synthesize gameBoardView = _gameBoardView;
@synthesize square = _square;
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
}

- (void)gameBoardViewTouchDown:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
    GameSquare      *square = [self.gameBoardView squareAtPoint:touchPt];
    GamePieceView   *pieceView = [self.gameBoardView pieceViewAtPoint:touchPt];
    NSLog(@"square(%d)", square.index);
    NSLog(@"pieceView: %@", pieceView);
    if (square) {
        self.square = square;
    }
    if (pieceView) {
        self.pieceView = pieceView;
        self.startLocation = touchPt;
    }
}

- (void)gameBoardViewTouchMove:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
    if (self.pieceView) {
        CGRect  frame = [self.pieceView frame];
        frame.origin.x += touchPt.x - self.startLocation.x;
        frame.origin.y += touchPt.y - self.startLocation.y;
        self.startLocation = touchPt;
        [self.pieceView setFrame:frame];
    }
}

- (void)gameBoardViewTouchUp:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event
{
    BOOL    isMove = NO;
    if (self.pieceView) {
        GameSquare      *square = [self.gameBoardView squareAtPoint:touchPt];
        if ((square.isEmpty) && ([square isNeighborhood:self.square])) {
            [self.pieceView moveWithSquare:square];
            self.square.isEmpty = YES;
            square.isEmpty = NO;
            isMove = YES;
        }
        else {
            [self.pieceView moveWithSquare:self.square];
        }
    }
    self.pieceView = nil;
    
    /* ゲームクリアの判定 */
    if (isMove) {
        [self checkGameClear];
    }
}

- (void)checkGameClear
{
    BOOL    isClear = YES;
    for (int i=0; i < 15; i++) {
        GameSquare  *square = [self.gameBoardView squareAtIndex:i];
        GamePieceView   *pieceView = [self.gameBoardView pieceViewAtIndex:i];
        if (! CGRectEqualToRect(square.frame, pieceView.frame)) {
            isClear = NO;
            break;
        }
    }
    if (isClear) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ゲームクリア" message:@"おめでとう！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DBGMSG(@"%s, buttonIndex(%d)", __func__, (int)buttonIndex);
}

@end
