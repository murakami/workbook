//
//  OneViewController.h
//  ContainerVC
//
//  Created by 村上 幸雄 on 12/09/23.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVCViewController;

@interface OneViewController : UIViewController

@property (nonatomic, strong) CVCViewController *cvcViewController;

- (IBAction)toggleVC:(id)sender;

@end
