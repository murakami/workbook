//
//  GameBoardView.h
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameBoardView;
@class GameSquare;
@class GamePiece;

@protocol GameBoardViewDelegate <NSObject>
- (void)gameBoardViewTouchDown:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event;
- (void)gameBoardViewTouchMove:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event;
- (void)gameBoardViewTouchUp:(GameBoardView *)gameBoardView location:(CGPoint)touchPt taps:(int)taps event:(UIEvent*)event;
@end

@interface GameBoardView : UIView
@property (nonatomic, weak) id<GameBoardViewDelegate>   delegate;

-(GameSquare*)squareAtPoint:(CGPoint)pt;
-(GameSquare*)squareAtIndex:(int)index;
-(GamePiece*)pieceAtPoint:(CGPoint)pt;
-(GamePiece*)pieceAtIndex:(int)index;

@end
