//
//  AppDelegate.m
//  DistributedServer
//
//  Created by 村上幸雄 on 2014/05/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "AppDelegate.h"

@protocol RemoteObjectProtocol
- (oneway void)receiveString:(NSString *)string;
@end

@interface AppDelegate () <RemoteObjectProtocol>
- (void)_registerForNotes;
- (void)_handleDistributedNote:(NSNotification *)note;
- (void)_registerForDistributedObjects;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"%s", __func__);
    // Insert code here to initialize your application
    
    [self _registerForNotes];
    [self _registerForDistributedObjects];
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
    [self.label setStringValue:@"Recieived Distributed Notification!"];
}

- (void)_registerForDistributedObjects
{
    NSLog(@"%s", __func__);
    NSConnection    *conn = [NSConnection defaultConnection];
    [conn setRootObject:self];
    if ([conn registerName:@"DistributedServer"] == NO) {
        NSLog(@"%s error", __func__);
    }
}

- (oneway void)receiveString:(NSString *)string
{
    NSLog(@"%s", __func__);
    [self.label setStringValue:string];
}

@end
