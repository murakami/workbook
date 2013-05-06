//
//  Document.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/06.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "Document.h"

@interface Document ()
@end

@implementation Document

@synthesize version = _version;

+ (Document *)sharedInstance
{
    static Document *_sharedInstance = nil;
    /*
    if (!_sharedInstance) {
		_sharedInstance = [[Document alloc] init];
	}
    */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Document alloc] init];
    });
	return _sharedInstance;
}

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
	//[super dealloc];
}

- (void)clearDefaults
{
    DBGMSG(@"%s", __func__);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"]) {
        DBGMSG(@"remove version:%@", self.version);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"version"];
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
    }
}

@end
