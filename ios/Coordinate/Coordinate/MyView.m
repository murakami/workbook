//
//  MyView.m
//  Coordinate
//
//  Created by 村上 幸雄 on 12/02/15.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyView.h"

@interface MyView ()
@end

@implementation MyView

@synthesize upperLeftOriginImage = _upperLeftOriginImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define BEST_BYTE_ALIGNMENT 16
#define COMPUTE_BEST_BYTES_PER_ROW(bpr)\
(((bpr) + (BEST_BYTE_ALIGNMENT - 1)) & ~(BEST_BYTE_ALIGNMENT -1))

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    self.upperLeftOriginImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"upper-left-origin.png" ofType:nil]];
}

-(void)dealloc
{
    self.upperLeftOriginImage = nil;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef    context = UIGraphicsGetCurrentContext();

    /* LLO(lower-left-origin) */
    size_t  witdh = rect.size.width;
    size_t  height = rect.size.height;
    size_t  bytesPerRow = witdh * 4;
    bytesPerRow = COMPUTE_BEST_BYTES_PER_ROW(bytesPerRow);
    unsigned char   *rasterData = calloc(1, bytesPerRow * height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef    ctx = CGBitmapContextCreate(rasterData, witdh, height,
                                                8, bytesPerRow,
                                                colorSpace,
                                                kCGImageAlphaPremultipliedFirst);
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(ctx, 4.0);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 5.0, 25.0);
    CGContextAddLineToPoint(ctx, 5.0, 5.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextMoveToPoint(ctx, 5.0, 5.0);
    CGContextAddLineToPoint(ctx, 25.0, 5.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGImageRef  cgimage = CGBitmapContextCreateImage(ctx);
    CGContextDrawImage(context, rect, cgimage);
    CGContextRelease(ctx);
    free(rasterData);
    CGColorSpaceRelease(colorSpace);

    /* ULO(upper-left-origin) */
    [self.upperLeftOriginImage drawAtPoint:CGPointMake(10.0, 10.0)];
    
    /* LLO(lower-left-origin) */
    CGContextSetLineWidth(context, 4.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10.0, 30.0);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextMoveToPoint(context, 10.0, 10.0);
    CGContextAddLineToPoint(context, 30.0, 10.0);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
