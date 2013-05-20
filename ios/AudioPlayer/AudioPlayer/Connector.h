//
//  Connector.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetBrowserResponseParser.h"

extern NSString *ConnectorDidBeginUpdateIPodLibrary;
extern NSString *ConnectorInProgressUpdateIPodLibrary;
extern NSString *ConnectorDidFinishUpdateIPodLibrary;

@interface Connector : NSObject <AssetBrowserParserDelegate>

@property (nonatomic, readonly, getter=isNetworkAccessig) BOOL  networkAccessing;
@property (nonatomic, readonly, getter=isAccessig) BOOL         accessing;
@property (strong, nonatomic) NSMutableArray                    *assetBrowserParsers;

+ (Connector *)sharedConnector;
- (void)updateIPodLibrary:(AssetBrowserSourceType)sourceType;
- (void)cancelUpdateIPodLibrary;

@end
