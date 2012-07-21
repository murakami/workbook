//
//  GamePieceView.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GamePieceView.h"

@interface GamePieceView ()
@end

@implementation GamePieceView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    /* [super dealloc]; */
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef    context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0);
    CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, self.frame);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

-(BOOL)pieceViewCheck:(CGPoint)point
{
    BOOL    result = NO;
    if (CGRectContainsPoint(self.frame, point)) {
        result = YES;
    }
    return result;
}

@end
