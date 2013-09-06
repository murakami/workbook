//
//  AppDelegate.m
//  StateRestoration
//
//  Created by 村上 幸雄 on 13/08/18.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "Document.h"
#import "AppDelegate.h"

@implementation AppDelegate

/* 状態情報復元前の初期化 */
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DBGMSG(@"%s", __func__);
    [[Document sharedDocument] load];
    return YES;
}

/* 状態情報復元後の初期化 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DBGMSG(@"%s", __func__);
    return YES;
}

/* 状態情報保存前のモデル保存 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    DBGMSG(@"%s", __func__);
    [[Document sharedDocument] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DBGMSG(@"%s", __func__);
    //[[Document sharedDocument] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DBGMSG(@"%s", __func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DBGMSG(@"%s", __func__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DBGMSG(@"%s", __func__);
    //[[Document sharedDocument] save];
}

/* 状態情報保存の有効化 */
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    DBGMSG(@"%s", __func__);
    return YES;
}

/* 状態情報復元の有効化 */
- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    DBGMSG(@"%s", __func__);
    return YES;
}

#pragma mark - Restoration

/* 版その他、アプリケーションの他の状態情報をエンコード */
- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder
{
    DBGMSG(@"%s", __func__);
}

/* 版その他、アプリケーションの他の状態情報をデコード */
- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
    DBGMSG(@"%s", __func__);
    [[UIApplication sharedApplication] extendStateRestoration];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DBGMSG(@"%s", __func__);
            [[UIApplication sharedApplication] completeStateRestoration];
        });
    });
    
    NSString *restoreBundleVersion = [coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey];
    DBGMSG(@"Restore bundle version = %@", restoreBundleVersion);
    
    NSNumber *restoreUserInterfaceIdiom = [coder decodeObjectForKey:UIApplicationStateRestorationUserInterfaceIdiomKey];
    DBGMSG(@"Restore User Interface Idiom = %d", restoreUserInterfaceIdiom.integerValue);
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                            coder:(NSCoder *)coder
{
    DBGMSG(@"%s", __func__);
    for (NSString *identifier in identifierComponents) {
        DBGMSG(@"identifier:%@", identifier);
    }
    return nil;
}

@end
