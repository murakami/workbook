//
//  ViewController.h
//  Dialog
//
//  Created by 村上 幸雄 on 12/05/28.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView   *modalPaneView;

- (IBAction)alertImage:(id)sender;
- (IBAction)modalPane:(id)sender;
- (IBAction)alertDismiss:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
