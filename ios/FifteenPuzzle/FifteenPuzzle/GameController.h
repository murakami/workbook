//
//  GameController.h
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoardView.h"

@interface GameController : NSObject <GameBoardViewDelegate>
@property(nonatomic, strong) GameBoardView  *gameBoardView;

- (id)initWithView:(GameBoardView *)view;
@end
