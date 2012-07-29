//
//  ViewController.h
//  IPCClient
//
//  Created by 村上 幸雄 on 12/07/29.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField    *textField;
@property (nonatomic, weak) IBOutlet UIButton       *button;

- (IBAction)send:(id)sender;

@end
