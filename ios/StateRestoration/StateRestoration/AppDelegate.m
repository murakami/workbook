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
    return YES;
}

/* 状態情報復元の有効化 */
- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

#pragma mark - Restoration

- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder
{
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
}

/*
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                            coder:(NSCoder *)coder
{
}
*/

@end
