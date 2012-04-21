//
//  ViewController.h
//  Tweets
//
//  Created by 村上 幸雄 on 12/04/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel      *tweetStatusLabel;
@property (strong, nonatomic) IBOutlet UITextView   *msgBoxTextView;

- (IBAction)tweet:(id)sender;
- (IBAction)tweet2:(id)sender;
- (IBAction)timeline:(id)sender;

@end
