//
//  AppDelegate.m
//  DistributedClient
//
//  Created by 村上幸雄 on 2014/05/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
- (void)_postNotes;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"%s", __func__);
    // Insert code here to initialize your application
    
    [self _postNotes];
}

- (void)_postNotes
{
    NSLog(@"%s", __func__);
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc postNotificationName:@"DemoDistributedNote"
                       object:nil];
}

@end
