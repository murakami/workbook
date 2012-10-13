//
//  DetailViewController.h
//  ContainerVC
//
//  Created by 村上 幸雄 on 12/10/13.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVCViewController;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, strong) CVCViewController *cvcViewController;

- (IBAction)toggleVC:(id)sender;

@end
