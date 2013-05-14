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
    return (self.assetBrowserParsers > 0);
}

- (BOOL)isAccessig
{
    return (self.assetBrowserParsers > 0);
}

- (void)updateIPodLibrary:(AssetBrowserSourceType)sourceType
{
    BOOL    networkAccessing;
    networkAccessing = self.networkAccessing;
    
    AssetBrowserParser*  parser;
    parser = [[AssetBrowserParser alloc] init];
    parser.sourceType = sourceType;
    parser.delegate = self;
    
    [parser parse];
    
    [self.assetBrowserParsers addObject:parser];
    
    if (networkAccessing != self.networkAccessing) {
        [self willChangeValueForKey:@"accessing"];
        [self didChangeValueForKey:@"accessing"];
    }
    
    NSMutableDictionary*    userInfo;
    userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidBeginUpdateIPodLibrary
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)cancelUpdateIPodLibrary
{
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
