//
//  Parser.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetBrowserParser;

typedef enum {
    kAssetBrowserSourceTypeNone,
	kAssetBrowserSourceTypePlaylists,
	kAssetBrowserSourceTypeArtists,
	kAssetBrowserSourceTypeSongs,
	kAssetBrowserSourceTypeAlbums
} AssetBrowserSourceType;

typedef enum {
    kAssetBrowserStateNone,
    kAssetBrowserStateInProgress,
    kAssetBrowserStateFinished,
    kAssetBrowserStateError,
    kAssetBrowserStateCanceled,
} AssetBrowserState;

@protocol AssetBrowserParserDelegate <NSObject>
- (void)parserDidFinishLoading:(AssetBrowserParser*)parser;
- (void)parser:(AssetBrowserParser*)parser didFailWithError:(NSError*)error;
- (void)parserDidCancel:(AssetBrowserParser*)parser;
@end

@interface AssetBrowserParser : NSObject

@property (assign, nonatomic) AssetBrowserSourceType        sourceType;
@property (readonly, nonatomic) AssetBrowserState           state;
@property (strong, nonatomic) NSMutableArray                *assetBrowserItems;
@property (readonly, nonatomic) NSError                     *error;
@property (weak, nonatomic) id<AssetBrowserParserDelegate>  delegate;

- (void)parse;
- (void)cancel;

@end
