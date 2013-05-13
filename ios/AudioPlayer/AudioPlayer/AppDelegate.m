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
@property (strong, nonatomic) UIAlertView               *alertView;
@property (strong, nonatomic) UIActivityIndicatorView   *activityIndicatorView;
- (void)_updateNetworkActivity;
- (void)_updateActivityAlert;
- (void)_presentActivityAlertWithText:(NSString *)alertText;
- (void)_setActivityAlertTitle:(NSString *)title;
- (void)_setActivityAlertMessage:(NSString *)message;
- (void)_dismissActivityAlert;
- (void)_setActivityIndicatorVisible:(BOOL)visible;
@end

@implementation AppDelegate

@synthesize alertView = _alertView;
@synthesize activityIndicatorView = _activityIndicatorView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Connector sharedConnector] addObserver:self
                                  forKeyPath:@"networkAccessing"
                                     options:0
                                     context:NULL];
    [[Connector sharedConnector] addObserver:self
                                  forKeyPath:@"accessing"
                                     options:0
                                     context:NULL];
    self.alertView = nil;
    self.activityIndicatorView = nil;
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
    else if ([keyPath isEqualToString:@"accessing"]) {
        [self _updateActivityAlert];
    }
}

- (void)_updateNetworkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = [Connector sharedConnector].networkAccessing;
}

- (void)_updateActivityAlert
{
    if ([Connector sharedConnector].accessing) {
        [self _presentActivityAlertWithText:@"Please Wait"];
    }
    else {
        [self _dismissActivityAlert];
    }
}

- (void)_presentActivityAlertWithText:(NSString *)title
{
    if (self.alertView) {
        self.alertView.title = title;
        [self.alertView show];
    }
    else {
        self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:@"\n\n\n\n\n\n"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
        [self.alertView show];
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.alertView.bounds), CGRectGetMidY(self.alertView.bounds));
        [self.activityIndicatorView startAnimating];
        
        [self.alertView addSubview:self.activityIndicatorView];
    }
}

- (void)_setActivityAlertTitle:(NSString *)title
{
    self.alertView.title = title;
}

- (void)_setActivityAlertMessage:(NSString *)aMessage
{
    NSString    *message = aMessage;
    while ([message componentsSeparatedByString:@"\n"].count < 7)
        message = [message stringByAppendingString:@"\n"];
    self.alertView.message = message;
}

- (void)_dismissActivityAlert
{
    if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
        self.alertView = nil;
    }
}

- (void)_setActivityIndicatorVisible:(BOOL)visible
{
    if (visible)
        [self.activityIndicatorView startAnimating];
    else
        [self.activityIndicatorView stopAnimating];
}

@end
