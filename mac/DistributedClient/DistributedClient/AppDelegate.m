//
//  AppDelegate.m
//  DistributedClient
//
//  Created by 村上幸雄 on 2014/05/05.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "AppDelegate.h"

@protocol RemoteObjectProtocol
- (oneway void)receiveString:(NSString *)string;
@end

@interface AppDelegate ()
- (void)_postNotes;
- (void)_postForDistributedObjects;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"%s", __func__);
    // Insert code here to initialize your application
    
    //[self _postNotes];
}

- (IBAction)postNotes:(id)sender
{
    NSLog(@"%s", __func__);
    [self _postNotes];
}

- (IBAction)postForDistributedObjects:(id)sender
{
    NSLog(@"%s", __func__);
    [self _postForDistributedObjects];
}

- (void)_postNotes
{
    NSLog(@"%s", __func__);
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc postNotificationName:@"DemoDistributedNote"
                       object:nil];
}

- (void)_postForDistributedObjects
{
    id  remoteObject;
    remoteObject = [NSConnection rootProxyForConnectionWithRegisteredName:@"DistributedServer"
                                                                     host:@""];
    [remoteObject setProtocolForProxy:@protocol(RemoteObjectProtocol)];
    [remoteObject receiveString:[NSString stringWithFormat:@"%@", [[NSDate date] description]]];
}

@end
