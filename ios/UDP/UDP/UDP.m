//
//  UDP.m
//  UDP
//
//  Created by 村上幸雄 on 2015/01/19.
//  Copyright (c) 2015年 村上幸雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDP.h"

#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

@implementation UDP

- (id)init
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)startServerOnPort:(NSUInteger)port
{
}

- (void)startConnectedToHostName:(NSString *)hostName port:(NSUInteger)port
{
}

- (void)sendData:(NSData *)data
{
}

- (void)stop
{
}

@end

/* End Of File */