//
//  Document.m
//  Defaults
//
//  Created by 村上 幸雄 on 12/01/30.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize message = _message;

- (id)init
{
    DBGMSG(@"%s", __func__);
	if ((self = [super init]) != nil) {
	}
	return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
	//[super dealloc];
}

- (void)clearDefaults
{
    DBGMSG(@"%s", __func__);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"message"]) {
        DBGMSG(@"remove message:%@", self.message);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"message"];
    }
}

- (void)updateDefaults
{
    DBGMSG(@"%s", __func__);
    NSString    *aMessage = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"message"]) {
        aMessage = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
        DBGMSG(@"current aMessage:%@", aMessage);
    }
    if (self.message) {
        if ((aMessage) && ([aMessage compare:self.message] == NSOrderedSame)) {
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:self.message forKey:@"message"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            DBGMSG(@"save message:%@", self.message);
        }
    }
}

- (void)loadDefaults
{
    DBGMSG(@"%s", __func__);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"message"]) {
        self.message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
        DBGMSG(@"read message:%@", self.message);
    }
}

@end
