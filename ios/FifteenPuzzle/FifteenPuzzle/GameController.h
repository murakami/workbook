//
//  GameController.h
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoardView.h"
#import "GameSquare.h"
#import "GamePieceView.h"

@interface GameController : NSObject <GameBoardViewDelegate, GamePieceViewDelegate>
@property(nonatomic, strong) GameBoardView  *gameBoardView;

- (id)initWithView:(GameBoardView *)view;
@end
