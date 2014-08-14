//
//  Document.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/06.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject
@property (strong, nonatomic) NSString  *title;
@end

@interface Playlists : NSObject
@property (strong, nonatomic) NSArray   *playlistsArray;
@end

@interface Document : NSObject
@property (strong, nonatomic) NSString  *version;
@property (strong, nonatomic) NSArray   *playlists;
@property (strong, nonatomic) NSArray   *artists;
@property (strong, nonatomic) NSArray   *albums;
+ (Document *)sharedInstance;
- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;
@end
