//
//  ViewController.h
//  AugmentedReality
//
//  Created by 村上 幸雄 on 13/07/09.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView     *augmentedRealityView;
@property (weak, nonatomic) IBOutlet UILabel    *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel    *headingLabel;

@end
