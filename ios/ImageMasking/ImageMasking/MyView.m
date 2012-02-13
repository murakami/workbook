//
//  MyView.m
//  ImageMasking
//
//  Created by 村上 幸雄 on 12/02/13.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyView.h"

@interface MyView ()
- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
@end

@implementation MyView

@synthesize image = _image;
@synthesize mask = _mask;
@synthesize imageMaskedWithImage = _imageMaskedWithImage;

- (id)initWithFrame:(CGRect)frame
{
    DBGMSG(@"%s", __func__);
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
    self.mask = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mask.png" ofType:nil]];
    self.imageMaskedWithImage = [self maskImage:self.image withMask:self.mask];
}

-(void)dealloc
{
    self.image = nil;
    self.mask = nil;
    self.imageMaskedWithImage = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.imageMaskedWithImage drawAtPoint:CGPointMake(10.0, 10.0)];
}

- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    
	CGImageRef maskRef = maskImage.CGImage; 
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef),
                                        NULL,
                                        false);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    CGImageRelease(mask);
	return [UIImage imageWithCGImage:masked];
}

@end
