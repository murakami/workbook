//
//  AppDelegate.h
//  LocalNotification
//
//  Created by 村上 幸雄 on 12/02/02.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property UIBackgroundTaskIdentifier    bgTask;

@end
