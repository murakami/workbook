//
//  GameSquare.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameSquare.h"

@implementation GameSquare

@synthesize frame = _frame;
@synthesize index = _index;

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
    //CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, self.frame);
    //CGContextFillPath(context);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

-(BOOL)squareCheck:(CGPoint)point
{
    return NO;
}

@end
