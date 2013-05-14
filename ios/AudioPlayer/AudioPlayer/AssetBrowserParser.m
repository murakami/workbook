//
//  Parser.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "AssetBrowserParser.h"

#define ENUM_QUEUE  [AssetBrowserParser sharedQueue]

@interface AssetBrowserParser ()
@property (readwrite, nonatomic) AssetBrowserState  state;
@property (readwrite, nonatomic) NSError            *error;
- (void)_parse;
@end

@implementation AssetBrowserParser

@synthesize sourceType = _sourceType;
@synthesize state = _state;
@synthesize assetBrowserItems = _assetBrowserItems;
@synthesize error = error;
@synthesize delegate = _delegate;

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t enumerationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        enumerationQueue = dispatch_queue_create("AssetBrowserParser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(enumerationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
    });
	return enumerationQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sourceType = kAssetBrowserSourceTypeNone;
        self.state = kAssetBrowserStateNone;
        self.assetBrowserItems = [[NSMutableArray alloc] init];
        self.error = nil;
        self.delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    self.sourceType = kAssetBrowserSourceTypeNone;
    self.state = kAssetBrowserStateNone;
    self.assetBrowserItems = nil;
    self.error = nil;
    self.delegate = nil;
}

- (void)parse
{
    dispatch_async(ENUM_QUEUE, ^(void) {
        [self _parse];
	});
}

- (void)_parse
{
}

- (void)cancel
{
}

@end
