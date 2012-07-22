//
//  GamePieceView.h
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameSquare;
@class GamePieceView;

@protocol GamePieceViewDelegate
@end

@interface GamePieceView : UIView
@property (nonatomic, weak) id<GamePieceViewDelegate, NSObject> delegate;

- (id)initWithFrame:(CGRect)frame;
- (BOOL)pieceViewCheck:(CGPoint)point;
- (void)moveWithSquare:(GameSquare *)square;
@end
