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
    
    /* 現状の描画環境を保存 */
    CGContextSaveGState(context);
    
    /*
     * a--b--c
     * |  |  |
     * d--e--f
     * |  |  |
     * g--h--i
     */
    /* d点に移動 */
    CGContextMoveToPoint(context, minX, midY);
    
    /* 左下：線分dgと線分ghに接する半径radiusの円弧を追加 */
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    
    /* 右下：線分hiと線分ifに接する半径radiusの円弧を追加 */
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    
    /* 右上：線分fcと線分cbに接する半径radiusの円弧を追加 */
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    
    /* 左上：線分baと線分adに接する半径radiusの円弧を追加 */
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    
    /* パスを閉じる */
    CGContextClosePath(context);
    
    /* 先ほどのパスをクリップ領域として設定 */
    CGContextClip(context);
    
    /* 描画 */
    [self.image drawAtPoint:CGPointMake(10.0, 10.0)];
    
    /* 描画環境を先ほどの保存時点に戻す */
    CGContextRestoreGState(context);
}

@end
