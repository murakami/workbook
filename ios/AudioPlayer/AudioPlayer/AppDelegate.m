//
//  AppDelegate.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/04/21.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "Connector.h"
#import "AppDelegate.h"

@interface AppDelegate ()
- (void)_updateNetworkActivity;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Connector sharedConnector] addObserver:self
                                  forKeyPath:@"networkAccessing"
                                     options:0
                                     context:NULL];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if ([keyPath isEqualToString:@"networkAccessing"]) {
        [self _updateNetworkActivity];
    }
}

- (void)_updateNetworkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = [Connector sharedConnector].networkAccessing;
}

@end
