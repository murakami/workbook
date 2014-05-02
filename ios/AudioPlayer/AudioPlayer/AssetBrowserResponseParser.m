//
//  Parser.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "AssetBrowserResponseParser.h"

#define ENUM_QUEUE  [AssetBrowserResponseParser sharedQueue]

NSString    *AssetBrowserErrorDomain = @"AssetBrowserErrorDomain";

@interface AssetBrowserResponseParser ()
@property (readwrite, nonatomic) AssetBrowserState  state;
@property (readwrite, nonatomic) NSError            *error;
@property (assign, nonatomic) BOOL                  isCancel;
- (void)_parse;
- (void)_parsePlaylists;
- (void)_parseArtists;
- (void)_parseSongs;
- (void)_parseAlbums;
- (void)_notifyParserDidFinishLoading;
- (void)_notifyParserDidFailWithError:(NSError *)error;
@end

@implementation AssetBrowserResponseParser

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
        enumerationQueue = dispatch_queue_create("AssetBrowserResponseParser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(enumerationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
    });
	return enumerationQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        _sourceType = kAssetBrowserSourceTypeNone;
        _state = kAssetBrowserStateNone;
        _assetBrowserItems = [[NSMutableArray alloc] init];
        _error = nil;
        _delegate = nil;
        _completionHandler = NULL;
        _isCancel = NO;
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
    self.completionHandler = NULL;
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
        if (kAssetBrowserSourceTypePlaylists == self.sourceType) {
            [self _parsePlaylists];
        }
        else if (kAssetBrowserSourceTypeArtists == self.sourceType) {
            [self _parseArtists];
        }
        else if (kAssetBrowserSourceTypeSongs == self.sourceType) {
            [self _parseSongs];
        }
        else if (kAssetBrowserSourceTypeAlbums == self.sourceType) {
            [self _parseAlbums];
        }
        
        if (self.error) {
            self.state = kAssetBrowserStateError;
            __block AssetBrowserResponseParser * __weak blockWeakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                AssetBrowserResponseParser *tempSelf = blockWeakSelf;
                if (! tempSelf)  return;
                [self _notifyParserDidFailWithError:tempSelf.error];
            });
        }
        else {
            self.state = kAssetBrowserStateFinished;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _notifyParserDidFinishLoading];
            });
        }
}

- (void)_parsePlaylists
{
    NSMutableArray  *playlistsArray = [[NSMutableArray alloc] init];
    MPMediaQuery    *playlistsQuery = [MPMediaQuery playlistsQuery];
    NSArray         *playlists = [playlistsQuery collections];
    for (MPMediaPlaylist *playlist in playlists) {
        NSString    *title = [playlist valueForProperty:MPMediaPlaylistPropertyName];
        NSLog(@"mediaItem:%@", title);
        
        NSMutableDictionary *playlistDictionary = [[NSMutableDictionary alloc] init];
        [playlistDictionary setObject:title forKey:@"title"];
        
        NSMutableArray  *songsArray = [[NSMutableArray alloc] init];
        NSArray         *songs = [playlist items];
        for (MPMediaItem *song in songs) {
            NSURL   *url = (NSURL*)[song valueForProperty:MPMediaItemPropertyAssetURL];
            if (url) {
                NSString    *songTitle = (NSString*)[song valueForProperty:MPMediaItemPropertyTitle];
                NSLog(@"song:%@", (NSString *)[song valueForProperty:MPMediaItemPropertyTitle]);
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:url forKey:@"URL"];
                [dict setObject:songTitle forKey:@"title"];
                [songsArray addObject:dict];
            }
        }
        [playlistDictionary setObject:songsArray forKey:@"songs"];
        [playlistsArray addObject:playlistDictionary];
        
#if 0
        NSArray         *songs = [playlist items];
        for (MPMediaItem *song in songs) {
            NSURL   *url = (NSURL *)[song valueForProperty:MPMediaItemPropertyAssetURL];
            if (url) {
                NSString *songTitle = (NSString *)[song valueForProperty:MPMediaItemPropertyTitle];
                NSLog(@"song:%@", songTitle);
                //NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                //[dict setObject:url forKey:@"URL"];
                //[dict setObject:title forKey:@"title"];
                //[songsList addObject:dict];
            }
        }
#endif
    }
    self.assetBrowserItems = [playlistsArray copy];

#if 0
    NSMutableArray  *PlaylistsList = [[NSMutableArray alloc] init];
    MPMediaQuery    *playlistsQuery = [MPMediaQuery playlistsQuery];
    NSArray         *playlistsArray = [playlistsQuery collections];
    for (MPMediaPlaylist *playlist in playlistsArray) {
        @autoreleasepool {
            if (self.isCancel) {
                NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:@"cancel" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"AssetBrowserResponseParser" code:kAssetBrowserCodeCancel userInfo:userInfo];
                self.error = error;
                break;
            }
            
            NSString    *title = [playlist valueForProperty:MPMediaPlaylistPropertyName];
            if (title) {
                NSMutableArray  *songsList = [[NSMutableArray alloc] init];
                NSArray         *songs = [playlist items];
                for (MPMediaItem *song in songs) {
                    NSURL   *url = (NSURL *)[song valueForProperty:MPMediaItemPropertyAssetURL];
                    if (url) {
                        NSString *songTitle = (NSString *)[song valueForProperty:MPMediaItemPropertyTitle];
                        NSLog(@"song:%@", songTitle);
                        NSMutableDictionary *songDict = [[NSMutableDictionary alloc] init];
                        [songDict setObject:url forKey:@"URL"];
                        [songDict setObject:title forKey:@"title"];
                        [songsList addObject:songDict];
                    }
                }
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:title forKey:@"title"];
                [dict setObject:songsList forKey:@"songs"];
                
                [PlaylistsList addObject:dict];
            }
        }
    }
#endif
}

- (void)_parseArtists
{
    /* 芸術家一覧の取得 */
    MPMediaQuery    *artistsQuery = [MPMediaQuery artistsQuery];
    NSArray         *artistsArray = [artistsQuery collections];
    for (MPMediaItemCollection *mediaItemCollection in artistsArray) {
        @autoreleasepool {
            MPMediaItem *mediaItem = [mediaItemCollection representativeItem];
            NSString    *artistName = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
            NSLog(@"artist:%@", artistName);
            
            /* アルバム一覧の取得 */
            MPMediaQuery    *albumsQuery = [[MPMediaQuery alloc] init];
            [albumsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:artistName
                                                                             forProperty:MPMediaItemPropertyArtist]];
            [albumsQuery setGroupingType:MPMediaGroupingAlbum];
            NSArray *albums = [albumsQuery collections];
            for (MPMediaItemCollection *album in albums) {
                MPMediaItem *representativeItem = [album representativeItem];
                NSString *albumTitle = [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
                NSLog(@" album:%@", albumTitle);
                
                /* 曲一覧の取得 */
                NSArray *songs = [album items];
                for (MPMediaItem *song in songs) {
                    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                    NSLog(@"  song:%@", songTitle);
                }
            }
        }
    }
}

- (void)_parseSongs
{
    NSMutableArray  *songsList = [[NSMutableArray alloc] init];
    MPMediaQuery    *songsQuery = [MPMediaQuery songsQuery];
    NSArray         *mediaItems = [songsQuery items];
    for (MPMediaItem *mediaItem in mediaItems) {
        @autoreleasepool {
            if (self.isCancel) {
                NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:@"cancel" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"AssetBrowserResponseParser" code:kAssetBrowserCodeCancel userInfo:userInfo];
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
    }
    self.assetBrowserItems = [songsList copy];
}

- (void)_parseAlbums
{
    MPMediaQuery    *albumsQuery = [MPMediaQuery albumsQuery];
    NSArray         *albumsArray = [albumsQuery collections];
    for (MPMediaItemCollection *mediaItemCollection in albumsArray) {
        @autoreleasepool {
            MPMediaItem *mediaItem = [mediaItemCollection representativeItem];
            NSString    *title = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSLog(@"mediaItem:%@", title);
            
            NSArray         *songs = [mediaItemCollection items];
            for (MPMediaItem *song in songs) {
                NSURL   *url = (NSURL *)[song valueForProperty:MPMediaItemPropertyAssetURL];
                if (url) {
                    NSString *songTitle = (NSString *)[song valueForProperty:MPMediaItemPropertyTitle];
                    NSLog(@"song:%@", songTitle);
                    //NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    //[dict setObject:url forKey:@"URL"];
                    //[dict setObject:title forKey:@"title"];
                    //[songsList addObject:dict];
                }
            }
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
    if (self.completionHandler) {
        self.completionHandler(self);
    }
}

- (void)_notifyParserDidFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [self.delegate parser:self didFailWithError:error];
    }
    if (self.completionHandler) {
        self.completionHandler(self);
    }
}

@end
