//
//  DetailViewController.h
//  StateRestoration
//
//  Created by 村上 幸雄 on 13/08/18.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (assign, nonatomic) NSInteger         detailItemIndex;

@property (weak, nonatomic) IBOutlet UILabel    *detailDescriptionLabel;
@end
