//
//  GamePieceView.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GamePieceView.h"

@implementation GamePieceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    /* [super dealloc]; */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(BOOL)pieceViewCheck:(CGPoint)point
{
    BOOL    result = NO;
    if (CGRectContainsPoint(self.frame, point)) {
        result = YES;
    }
    return result;
}

@end
