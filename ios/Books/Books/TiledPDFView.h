//
//  TiledPDFView.h
//  Books
//
//  Created by 村上 幸雄 on 12/04/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TiledPDFView : UIView

@property (nonatomic, assign) CGPDFPageRef  pdfPage;
@property (nonatomic, assign) CGFloat       myScale;

- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;

@end
