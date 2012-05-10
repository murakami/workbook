//
//  LayerViewController.h
//  CoreAnimation
//
//  Created by 村上 幸雄 on 12/05/11.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LayerViewController : UIViewController

@property (strong, nonatomic) UIImage   *backgroundImage;
@property (strong, nonatomic) UIImage   *frontImage;
@property (strong, nonatomic) UIImage   *rearImage;
@property (strong, nonatomic) CALayer   *cardLayer;

@end
