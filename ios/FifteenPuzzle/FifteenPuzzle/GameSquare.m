//
//  GameSquare.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameSquare.h"

@interface GameSquare ()
@end

@implementation GameSquare

@synthesize frame = _frame;
@synthesize index = _index;
@synthesize isEmpty = _isEmpty;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.index = -1;
    }
    return self;
}

- (void)drawContext:(CGContextRef)context
{
    DBGMSG(@"%s", __func__);
    UIGraphicsPushContext(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0.7, 0.7, 0.7, 1.0);
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, self.frame);
    CGContextStrokePath(context);
    CGContextSelectFont(context, "Helvetica", 12.0, kCGEncodingMacRoman);
    char    s[32];
    sprintf(s, "%d", self.index);
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextShowTextAtPoint(context, self.frame.origin.x + 5.0, self.frame.origin.y + 17.0, s, strlen(s));
    UIGraphicsPopContext();
}

-(BOOL)squareCheck:(CGPoint)point
{
	BOOL    result = NO;
	if (CGRectContainsPoint(self.frame, point)) {
		result = YES;
	}
	return result;
}

- (BOOL)isNeighborhood:(GameSquare *)square
{
    BOOL    result = NO;
    CGFloat myLeft = self.frame.origin.x;
    CGFloat myRight = self.frame.origin.x + self.frame.size.width;
    CGFloat myTop = self.frame.origin.y;
    CGFloat myBottom = self.frame.origin.y + self.frame.size.height;
    CGFloat nextLeft = square.frame.origin.x;
    CGFloat nextRight = square.frame.origin.x + square.frame.size.width;
    CGFloat nextTop = square.frame.origin.y;
    CGFloat nextBottom = square.frame.origin.y + square.frame.size.height;
    
    /* 左隣 */
    if ((myLeft == nextRight) && (myTop == nextTop) && (myBottom == nextBottom)) {
        result = YES;
    }
    /* 右隣 */
    else if ((myRight == nextLeft) && (myTop == nextTop) && (myBottom == nextBottom)) {
        result = YES;
    }
    /* 上隣 */
    else if ((myLeft == nextLeft) && (myRight == nextRight) && (myTop == nextBottom)) {
        result = YES;
    }
    /* 下隣 */
    else if ((myLeft == nextLeft) && (myRight == nextRight) && (myBottom == nextTop)) {
        result = YES;
    }
    return result;
}

@end
