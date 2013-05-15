//
//  Parser.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "AssetBrowserParser.h"

#define ENUM_QUEUE  [AssetBrowserParser sharedQueue]

NSString    *AssetBrowserErrorDomain = @"AssetBrowserErrorDomain";

@interface AssetBrowserParser ()
@property (readwrite, nonatomic) AssetBrowserState  state;
@property (readwrite, nonatomic) NSError            *error;
@property (assign, nonatomic) BOOL                  isCancel;
- (void)_parse;
- (void)_notifyParserDidFinishLoading;
- (void)_notifyParserDidFailWithError:(NSError *)error;
@end

@implementation AssetBrowserParser

@synthesize sourceType = _sourceType;
@synthesize state = _state;
@synthesize assetBrowserItems = _assetBrowserItems;
@synthesize error = _error;
@synthesize delegate = _delegate;
@synthesize isCancel = _isCancel;

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
        self.isCancel = NO;
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
    self.isCancel = NO;
}

- (void)parse
{
    dispatch_async(ENUM_QUEUE, ^(void) {
        [self _parse];
	});
}

- (void)_parse
{
    @autoreleasepool {
        if (kAssetBrowserSourceTypePlaylists == self.sourceType) {
        }
        else if (kAssetBrowserSourceTypeArtists == self.sourceType) {
        }
        else if (kAssetBrowserSourceTypeSongs == self.sourceType) {
            NSMutableArray  *songsList = [[NSMutableArray alloc] init];
            MPMediaQuery    *songsQuery = [MPMediaQuery songsQuery];
            NSArray         *mediaItems = [songsQuery items];
            for (MPMediaItem *mediaItem in mediaItems) {
                if (self.isCancel) {
                    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:@"cancel" forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"AssetBrowserParser" code:kAssetBrowserCodeCancel userInfo:userInfo];
                    self.error = error;
                    break;
                }
                
                NSURL   *url = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
                if (url) {
                    NSString    *title = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:url forKey:@"URL"];
                    [dict setObject:title forKey:@"title"];
                    [songsList addObject:dict];
                }
            }
            self.assetBrowserItems = [songsList copy];
        }
        else if (kAssetBrowserSourceTypeAlbums == self.sourceType) {
        }
        
        if (self.error) {
            self.state = kAssetBrowserStateError;
            [self performSelectorOnMainThread:@selector(_notifyParserDidFailWithError:)
                                   withObject:self.error
                                waitUntilDone:YES];
        }
        else {
            self.state = kAssetBrowserStateFinished;
            [self performSelectorOnMainThread:@selector(_notifyParserDidFinishLoading) 
                                   withObject:self.error
                                waitUntilDone:YES];
        }
    }
}

- (void)cancel
{
    @synchronized(self) {
        self.isCancel = YES;
    }
}

- (void)_notifyParserDidFinishLoading
{
    if ([self.delegate respondsToSelector:@selector(parserDidFinishLoading:)]) {
        [self.delegate parserDidFinishLoading:self];
    }
}

- (void)_notifyParserDidFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [self.delegate parser:self didFailWithError:error];
    }
}

@end
