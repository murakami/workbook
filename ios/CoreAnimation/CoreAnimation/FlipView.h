//
//  FlipView.h
//  CoreAnimation
//
//  Created by 村上 幸雄 on 12/03/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipView : UIView

@property (strong, nonatomic) UIImageView   *imageView;
@property (assign, nonatomic) BOOL          isAtMark;
@property (strong, nonatomic) UIImage       *atmarkImage;
@property (strong, nonatomic) UIImage       *arrowImage;

@end
