//
//  ViewController.h
//  PushNotification
//
//  Created by 村上 幸雄 on 12/05/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConnectionViewController;

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch         *receiveNotificationSwitch;
@property (strong, nonatomic) IBOutlet UILabel          *messageLabel;
@property (strong, nonatomic) ConnectionViewController  *connectionViewController;

- (IBAction)toggleReceiveNotification:(id)sender;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (NSString *)hexDumpString:(NSData *)data;
- (NSData *)formEncodedDataFromDictionary:(NSDictionary *)dict;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
