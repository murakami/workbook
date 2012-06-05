//
//  Document.m
//  Exam
//
//  Created by 村上 幸雄 on 12/06/05.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize version = _version;
@synthesize message = _message;

- (id)init
{
    DBGMSG(@"%s", __func__);
	if ((self = [super init]) != nil) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NSString    *aVersion = @"1.0";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
            aVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        }
        if ([aVersion compare:self.version] != NSOrderedSame) {
            [self clearDefaults];
        }
	}
	return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.version = nil;
    self.message = nil;
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
    BOOL    fUpdate = NO;
    
    NSString    *aVersion = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        aVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        DBGMSG(@"current aVersion:%@", aVersion);
    }
    if (self.version) {
        if ([aVersion compare:self.version] != NSOrderedSame) {
            [[NSUserDefaults standardUserDefaults] setObject:self.version forKey:@"version"];
            fUpdate = YES;
            DBGMSG(@"save version:%@", self.version);
        }
    }
    
    NSString    *aMessage = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"message"]) {
        aMessage = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
        DBGMSG(@"current aMessage:%@", aMessage);
    }
    if (self.message) {
        if ([aMessage compare:self.message] != NSOrderedSame) {
            [[NSUserDefaults standardUserDefaults] setObject:self.message forKey:@"message"];
            fUpdate = YES;
            DBGMSG(@"save message:%@", self.message);
        }
    }
    
    if (fUpdate) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadDefaults
{
    DBGMSG(@"%s", __func__);
    NSString    *aVersion = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        aVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    }
    if ([aVersion compare:self.version] != NSOrderedSame) {
        [self clearDefaults];
    }
    else {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"message"]) {
            self.message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
            DBGMSG(@"read message:%@", self.message);
        }
    }
}

@end
