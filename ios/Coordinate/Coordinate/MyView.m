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
    DBGMSG(@"%s", __func__);
    self.upperLeftOriginImage = nil;
}

- (void)drawRect:(CGRect)rect
{
    DBGMSG(@"%s", __func__);
    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    /* ULO(upper-left-origin) */
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef    bitmapContext = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(bitmapContext, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(bitmapContext, 4.0);
    CGContextBeginPath(bitmapContext);
    CGContextMoveToPoint(bitmapContext, 5.0, 25.0);
    CGContextAddLineToPoint(bitmapContext, 5.0, 5.0);
    CGContextDrawPath(bitmapContext, kCGPathStroke);
    CGContextMoveToPoint(bitmapContext, 5.0, 5.0);
    CGContextAddLineToPoint(bitmapContext, 25.0, 5.0);
    CGContextDrawPath(bitmapContext, kCGPathStroke);

    UIImage*    uiimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [uiimage drawAtPoint:CGPointMake(0.0, 0.0)];

#if 0
    /* LLO(lower-left-origin) */
    size_t  witdh = rect.size.width;
    size_t  height = rect.size.height;
    size_t  bytesPerRow = witdh * 4;
    bytesPerRow = COMPUTE_BEST_BYTES_PER_ROW(bytesPerRow);
    unsigned char   *rasterData = calloc(1, bytesPerRow * height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef    bitmapContext = CGBitmapContextCreate(rasterData, witdh, height,
                                                8, bytesPerRow,
                                                colorSpace,
                                                kCGImageAlphaPremultipliedLast);
    
    CGContextSetRGBStrokeColor(bitmapContext, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(bitmapContext, 4.0);
    CGContextBeginPath(bitmapContext);
    CGContextMoveToPoint(bitmapContext, 5.0, 25.0);
    CGContextAddLineToPoint(bitmapContext, 5.0, 5.0);
    CGContextDrawPath(bitmapContext, kCGPathStroke);
    CGContextMoveToPoint(bitmapContext, 5.0, 5.0);
    CGContextAddLineToPoint(bitmapContext, 25.0, 5.0);
    CGContextDrawPath(bitmapContext, kCGPathStroke);

    CGImageRef  cgimage = CGBitmapContextCreateImage(bitmapContext);
    CGContextDrawImage(context, rect, cgimage);
    /*
    UIImage *uiimage = [[UIImage alloc] initWithCGImage:cgimage];
    NSData  *data = UIImagePNGRepresentation(uiimage);
    NSString    *filePath = [NSString stringWithFormat:@"%@/demo.png" ,
                          [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    NSLog(@"%@", filePath);
    [data writeToFile:filePath atomically:YES];
    */
    CGContextRelease(bitmapContext);
    free(rasterData);
    CGColorSpaceRelease(colorSpace);
#endif

    /* ULO(upper-left-origin) */
    [self.upperLeftOriginImage drawAtPoint:CGPointMake(20.0, 20.0)];
    
    CGContextSetLineWidth(context, 4.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 20.0, 40.0);
    CGContextAddLineToPoint(context, 20.0, 20.0);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextMoveToPoint(context, 20.0, 20.0);
    CGContextAddLineToPoint(context, 40.0, 20.0);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
