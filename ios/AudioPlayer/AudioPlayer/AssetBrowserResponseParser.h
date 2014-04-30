//
//  Parser.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetBrowserResponseParser;

typedef enum {
    kAssetBrowserSourceTypeNone = 0,
	kAssetBrowserSourceTypePlaylists,
	kAssetBrowserSourceTypeArtists,
	kAssetBrowserSourceTypeSongs,
	kAssetBrowserSourceTypeAlbums
} AssetBrowserSourceType;

typedef enum {
    kAssetBrowserStateNone = 0,
    kAssetBrowserStateInProgress,
    kAssetBrowserStateFinished,
    kAssetBrowserStateError,
    kAssetBrowserStateCanceled,
} AssetBrowserState;

typedef enum {
    kAssetBrowserCodeSuccess = 0,
    kAssetBrowserCodeCancel,
    kAssetBrowserCodeFailure
} AssetBrowserCode;

extern NSString *AssetBrowserErrorDomain;

typedef void (^AssetBrowserResponseParserCompletionHandler)(AssetBrowserResponseParser *parser);

@protocol AssetBrowserResponseParserDelegate <NSObject>
- (void)parserDidFinishLoading:(AssetBrowserResponseParser *)parser;
- (void)parser:(AssetBrowserResponseParser *)parser didFailWithError:(NSError *)error;
- (void)parserDidCancel:(AssetBrowserResponseParser *)parser;
@end

@interface AssetBrowserResponseParser : NSObject

@property (assign, nonatomic) AssetBrowserSourceType                    sourceType;
@property (readonly, nonatomic) AssetBrowserState                       state;
@property (strong, nonatomic) NSMutableArray                            *assetBrowserItems;
@property (readonly, nonatomic) NSError                                 *error;
@property (weak, nonatomic) id<AssetBrowserResponseParserDelegate>      delegate;
@property (copy, nonatomic) AssetBrowserResponseParserCompletionHandler completionHandler;

- (void)parse;
- (void)cancel;

@end
