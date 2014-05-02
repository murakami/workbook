//
//  DetailViewController.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/04/25.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider       *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider       *rateSlider;
@property (strong, nonatomic) NSDictionary          *dict;

- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)currentTimeSliderDidChanged:(id)sender;
- (IBAction)rateSliderDidChanged:(id)sender;

@end
