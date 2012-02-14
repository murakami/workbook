//
//  ClippingADrawingView.m
//  ImageMasking
//
//  Created by 村上 幸雄 on 12/02/14.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ClippingADrawingView.h"

@interface ClippingADrawingView ()
@end

@implementation ClippingADrawingView

@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    self.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pict.png" ofType:nil]];
}

-(void)dealloc
{
    self.image = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef    context = UIGraphicsGetCurrentContext();
    CGSize  imageSize = self.image.size;
    CGRect  imageRect = {10.0, 10.0, imageSize.width, imageSize.height};
    float   radius = 10.0;
    CGFloat minX = CGRectGetMinX(imageRect);
    CGFloat midX = CGRectGetMidX(imageRect);
    CGFloat maxX = CGRectGetMaxX(imageRect);
    CGFloat minY = CGRectGetMinY(imageRect);
    CGFloat midY = CGRectGetMidY(imageRect);
    CGFloat maxY = CGRectGetMaxY(imageRect);
    
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, minX, midY);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    [self.image drawAtPoint:CGPointMake(10.0, 10.0)];
    CGContextRestoreGState(context);
}

@end
