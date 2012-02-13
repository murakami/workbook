//
//  MyView.h
//  ImageMasking
//
//  Created by 村上 幸雄 on 12/02/13.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView

@property (strong, nonatomic) UIImage   *image;
@property (strong, nonatomic) UIImage   *mask;
@property (strong, nonatomic) UIImage   *imageMaskedWithImage;

@end
