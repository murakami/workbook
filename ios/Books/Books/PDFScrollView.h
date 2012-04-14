//
//  PDFScrollView.h
//  Books
//
//  Created by 村上 幸雄 on 12/04/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TiledPDFView;

@interface PDFScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) TiledPDFView  *pdfView;
@property (strong, nonatomic) TiledPDFView  *oldPDFView;
@property (strong, nonatomic) UIImageView   *backgroundImageView;
@property (nonatomic, assign) CGFloat       pdfScale;
@property (nonatomic, assign) CGPDFPageRef  page;
@property (strong, nonatomic) Document      *document;

- (void)setIndexOfPDF:(NSUInteger)index;
- (NSUInteger)getIndexOfPDF;

@end
