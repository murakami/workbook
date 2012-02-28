//
//  AppDelegate.m
//  UnZip
//
//  Created by 村上 幸雄 on 12/02/28.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DBGMSG(@"%s", __func__);
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    DBGMSG(@"%s, filename(%@)", __func__, filename);
    return NO;
}

@end
