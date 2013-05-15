//
//  Connector.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "AssetBrowserParser.h"
#import "Connector.h"

NSString    *ConnectorDidBeginUpdateIPodLibrary = @"ConnectorDidBeginUpdateIPodLibrary";
NSString    *ConnectorInProgressUpdateIPodLibrary = @"ConnectorInProgressUpdateIPodLibrary";
NSString    *ConnectorDidFinishUpdateIPodLibrary = @"ConnectorDidFinishUpdateIPodLibrary";

@interface Connector ()
- (void)_notifyAssetBrowserStatusWithParser:(AssetBrowserParser*)parser;
@end

@implementation Connector

@synthesize assetBrowserParsers = _assetBrowserParsers;

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
        self.assetBrowserParsers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.assetBrowserParsers = nil;
}

- (BOOL)isNetworkAccessig
{
    return (0 < self.assetBrowserParsers);
}

- (BOOL)isAccessig
{
    return (0 < self.assetBrowserParsers);
}

- (void)updateIPodLibrary:(AssetBrowserSourceType)sourceType
{
    BOOL    accessing = self.accessing;
    
    AssetBrowserParser*  parser = [[AssetBrowserParser alloc] init];
    parser.sourceType = sourceType;
    parser.delegate = self;
    
    [parser parse];
    
    [self.assetBrowserParsers addObject:parser];
    
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
    NSMutableArray  *parsers = [self.assetBrowserParsers copy];
    for (AssetBrowserParser *parser in parsers) {
        [parser cancel];
        
        NSMutableDictionary*    userInfo;
        userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                            object:self
                                                          userInfo:userInfo];
        
        [self willChangeValueForKey:@"accessing"];
        [self.assetBrowserParsers removeObject:parser];
        [self didChangeValueForKey:@"accessing"];
    }
    parsers = nil;
#endif  /* 0 */
    for (AssetBrowserParser *parser in self.assetBrowserParsers) {
        [parser cancel];
    }
    
    NSMutableDictionary*    userInfo;
    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.assetBrowserParsers forKey:@"parsers"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                        object:self
                                                      userInfo:userInfo];
    
    [self willChangeValueForKey:@"accessing"];
    [self.assetBrowserParsers removeAllObjects];
    [self didChangeValueForKey:@"accessing"];
}

#pragma mark - AssetBrowserParserDelegate

- (void)_notifyAssetBrowserStatusWithParser:(AssetBrowserParser*)parser
{
    NSMutableDictionary*    userInfo;
    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                        object:self
                                                      userInfo:userInfo];
    
    [self willChangeValueForKey:@"accessing"];
    [self.assetBrowserParsers removeObject:parser];
    [self didChangeValueForKey:@"accessing"];
}

- (void)parserDidFinishLoading:(AssetBrowserParser*)parser
{
    if ([self.assetBrowserParsers containsObject:parser]) {
        [self _notifyAssetBrowserStatusWithParser:parser];
    }
}

- (void)parser:(AssetBrowserParser*)parser didFailWithError:(NSError*)error
{
    if ([self.assetBrowserParsers containsObject:parser]) {
        [self _notifyAssetBrowserStatusWithParser:parser];
    }
}

- (void)parserDidCancel:(AssetBrowserParser*)parser
{
    if ([self.assetBrowserParsers containsObject:parser]) {
        [self _notifyAssetBrowserStatusWithParser:parser];
    }
}

@end
