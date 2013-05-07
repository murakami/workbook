//
//  Connector.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *ConnectorDidBeginUpdateIPodLibrary;
extern NSString *ConnectorDidFinishUpdateIPodLibrary;

@interface Connector : NSObject <AssetBrowserParserDelegate>

@property (nonatomic, readonly, getter=isNetworkAccessig) BOOL  networkAccessing;
@property (strong, nonatomic) NSMutableArray                    *parsers;

+ (Connector *)sharedConnector;
- (void)updateIPodLibrary;
- (void)cancelUpdateIPodLibrary;

@end
