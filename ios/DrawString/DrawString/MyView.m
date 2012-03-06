//
//  MyView.m
//  DrawString
//
//  Created by 村上 幸雄 on 12/03/06.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef    context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
        
    CGFloat height = self.bounds.size.height;
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, - 1.0);
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(context, cs);
    CGColorSpaceRelease(cs);
        
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    CGContextSelectFont(context, "Helvetica", 48.0, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(context, 10.0, 10.0, "Quartz", strlen("Quartz"));

    CGContextFlush(context);
    CGContextRestoreGState(context);
    
    NSString    *str = @"NSString";
    [str drawAtPoint:CGPointMake(10.0, 20.0) withFont:[UIFont systemFontOfSize:48.0]];
}

@end
