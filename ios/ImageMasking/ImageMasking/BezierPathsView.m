//
//  BezierPathsView.m
//  ImageMasking
//
//  Created by 村上 幸雄 on 12/02/23.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "BezierPathsView.h"

@interface BezierPathsView ()
@end

@implementation BezierPathsView

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
    DBGMSG(@"%s", __func__);
    self.image = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef    context = UIGraphicsGetCurrentContext();
    CGSize  imageSize = self.image.size;
    CGRect  imageRect = {10.0, 10.0, imageSize.width, imageSize.height};
    float   radius = 10.0;
    
    /* 現状の描画環境を保存 */
    CGContextSaveGState(context);
    
    /* 四角形の四隅を半径radiusの円弧に */
    UIBezierPath*   aPath = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:radius];
    
    /* パスをクリップ領域として設定 */
    [aPath addClip];
    
    /* 描画 */
    [self.image drawAtPoint:CGPointMake(10.0, 10.0)];
    
    /* 描画環境を先ほどの保存時点に戻す */
    CGContextRestoreGState(context);
}

@end
