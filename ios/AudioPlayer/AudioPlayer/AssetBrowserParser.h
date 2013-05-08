//
//  Parser.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	AssetBrowserSourceTypePlaylists,
	AssetBrowserSourceTypeArtists,
	AssetBrowserSourceTypeSongs,
	AssetBrowserSourceTypeAlbums
} AssetBrowserSourceType;

@protocol AssetBrowserParserDelegate <NSObject>
@end

@interface AssetBrowserParser : NSObject

@property (assign, nonatomic) AssetBrowserSourceType        sourceType;
@property (strong, nonatomic) NSArray                       *assetBrowserItems;
@property (weak, nonatomic) id<AssetBrowserParserDelegate>  delegate;

- (void)parse;
- (void)cancel;

@end
