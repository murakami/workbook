//
//  AppDelegate.m
//  DistributedServer
//
//  Created by 村上幸雄 on 2014/05/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
- (void)_registerForNotes;
- (void)_handleDistributedNote:(NSNotification *)note;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"%s", __func__);
    // Insert code here to initialize your application
    
    [self _registerForNotes];
}

- (void)_registerForNotes
{
    NSLog(@"%s", __func__);
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self
            selector:@selector(_handleDistributedNote:)
                name:@"DemoDistributedNote"
              object:nil];
}

- (void)_handleDistributedNote:(NSNotification *)note
{
    NSLog(@"%s Recieived Distributed Notification!:%@", __func__, note);
}

@end
