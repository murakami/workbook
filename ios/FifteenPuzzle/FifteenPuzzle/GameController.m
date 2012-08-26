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
@property(nonatomic, strong) NSTimer        *gameTimer;
- (void)checkGameClear;
- (void)startTimer;
- (void)gameStart;
- (void)gameOver:(NSTimer*)theTimer;
@end

@implementation GameController

@synthesize gameBoardView = _gameBoardView;
@synthesize square = _square;
@synthesize pieceView = _pieceView;
@synthesize startLocation = _startLocation;
@synthesize gameTimer = _gameTimer;

- (id)initWithView:(GameBoardView *)view
{
    self = [super init];
    if (self) {
        self.gameBoardView = view;
        [self.gameBoardView setupWithDelegate:self];
        self.gameTimer = nil;
        
        /* 仮 */
        [self gameStart];
    }
    return self;
}

- (void)dealloc
{
    self.gameBoardView = nil;
    self.gameTimer = nil;
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
    [self gameStart];
}

- (void)doShake
{
    DBGMSG(@"%s", __func__);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ゲームスタート" message:@"ゲームを開始します！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
    [alertView show];
}

- (void)startTimer
{
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                      target:self
                                                    selector:@selector(gameOver:)
                                                    userInfo:nil repeats:NO];
}

- (void)gameStart
{
    /* 駒の配置も */
    [self startTimer];
}

- (void)gameOver:(NSTimer*)theTimer
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ゲームオーバー" message:@"残念！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
    [alertView show];
}

@end
