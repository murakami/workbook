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
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0.7, 0.7, 0.7, 1.0);
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, self.frame);
    //CGContextFillPath(context);
    CGContextStrokePath(context);
    CGContextSelectFont(context, "Helvetica", 12.0, kCGEncodingMacRoman);
    char    s[32];
    sprintf(s, "%d", self.index);
    CGContextShowTextAtPoint(context, self.frame.origin.x + 5.0, self.frame.origin.y + 5.0, s, strlen(s));
    UIGraphicsPopContext();
}

-(BOOL)squareCheck:(CGPoint)point
{
	BOOL    ret = NO;
	if (CGRectContainsPoint(self.frame, point)) {
		ret = YES;
	}
	return ret;
}

@end
