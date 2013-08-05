//
//  Connector.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "AssetBrowserResponseParser.h"
#import "Connector.h"

NSString    *ConnectorDidBeginUpdateIPodLibrary = @"ConnectorDidBeginUpdateIPodLibrary";
NSString    *ConnectorInProgressUpdateIPodLibrary = @"ConnectorInProgressUpdateIPodLibrary";
NSString    *ConnectorDidFinishUpdateIPodLibrary = @"ConnectorDidFinishUpdateIPodLibrary";

@interface Connector ()
- (void)_notifyAssetBrowserStatusWithParser:(AssetBrowserResponseParser*)parser;
@end

@implementation Connector

@synthesize assetBrowserResponseParsers = _assetBrowserResponseParsers;

+ (Connector *)sharedConnector
{
    static Connector *_sharedInstance = nil;
    /*
     if (!_sharedInstance) {
     _sharedInstance = [[Connector alloc] init];
     }
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Connector alloc] init];
    });
	return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.assetBrowserResponseParsers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.assetBrowserResponseParsers = nil;
}

- (BOOL)isNetworkAccessig
{
    return NO;
}

- (BOOL)isAccessig
{
    return (0 < self.assetBrowserResponseParsers.count);
}

- (void)updateIPodLibrary:(AssetBrowserSourceType)sourceType
{
    BOOL    accessing = self.accessing;
    
    AssetBrowserResponseParser*  parser = [[AssetBrowserResponseParser alloc] init];
    parser.sourceType = sourceType;
    parser.delegate = self;
    
    [parser parse];
    
    [self.assetBrowserResponseParsers addObject:parser];
    
    if (accessing != self.accessing) {
        [self willChangeValueForKey:@"accessing"];
        [self didChangeValueForKey:@"accessing"];
    }
    
    NSMutableDictionary*    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidBeginUpdateIPodLibrary
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)cancelUpdateIPodLibrary
{
#if 0
    NSMutableArray  *parsers = [self.assetResponseBrowserParsers copy];
    for (AssetBrowserResponseParser *parser in parsers) {
        [parser cancel];
        
        NSMutableDictionary*    userInfo;
        userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                            object:self
                                                          userInfo:userInfo];
        
        [self willChangeValueForKey:@"accessing"];
        [self.assetBrowserResponseParsers removeObject:parser];
        [self didChangeValueForKey:@"accessing"];
    }
    parsers = nil;
#endif  /* 0 */
    for (AssetBrowserResponseParser *parser in self.assetBrowserResponseParsers) {
        [parser cancel];
    }
    
    NSMutableDictionary*    userInfo;
    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.assetBrowserResponseParsers forKey:@"parsers"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                        object:self
                                                      userInfo:userInfo];
    
    [self willChangeValueForKey:@"accessing"];
    [self.assetBrowserResponseParsers removeAllObjects];
    [self didChangeValueForKey:@"accessing"];
}

#pragma mark - AssetBrowserResponseParserDelegate

- (void)_notifyAssetBrowserStatusWithParser:(AssetBrowserResponseParser*)parser
{
    NSMutableDictionary*    userInfo;
    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                        object:self
                                                      userInfo:userInfo];
    
    [self willChangeValueForKey:@"accessing"];
    [self.assetBrowserResponseParsers removeObject:parser];
    [self didChangeValueForKey:@"accessing"];
}

- (void)parserDidFinishLoading:(AssetBrowserResponseParser*)parser
{
    if ([self.assetBrowserResponseParsers containsObject:parser]) {
        [self _notifyAssetBrowserStatusWithParser:parser];
    }
}

- (void)parser:(AssetBrowserResponseParser*)parser didFailWithError:(NSError*)error
{
    if ([self.assetBrowserResponseParsers containsObject:parser]) {
        [self _notifyAssetBrowserStatusWithParser:parser];
    }
}

- (void)parserDidCancel:(AssetBrowserResponseParser*)parser
{
    if ([self.assetBrowserResponseParsers containsObject:parser]) {
        [self _notifyAssetBrowserStatusWithParser:parser];
    }
}

@end
