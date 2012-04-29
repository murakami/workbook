//
//  ViewController.h
//  REST
//
//  Created by 村上 幸雄 on 12/04/29.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView   *textView;

- (IBAction)sendPost:(id)sender;
- (IBAction)sendGet:(id)sender;
- (IBAction)sendGetList:(id)sender;
- (IBAction)sendPut:(id)sender;
- (IBAction)sendDelete:(id)sender;

@end
