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

@implementation Connector

@synthesize parsers = _parsers;

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
        self.parsers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.parsers = nil;
}

- (BOOL)isNetworkAccessig
{
    return (self.parsers > 0);
}

- (void)updateIPodLibrary:(AssetBrowserSourceType)sourceType
{
    BOOL    networkAccessing;
    networkAccessing = self.networkAccessing;
    
    AssetBrowserParser*  parser;
    parser = [[AssetBrowserParser alloc] init];
    parser.delegate = self;
    
    [parser parse];
    
    [self.parsers addObject:parser];
    
    if (networkAccessing != self.networkAccessing) {
        [self willChangeValueForKey:@"networkAccessing"];
        [self didChangeValueForKey:@"networkAccessing"];
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
    NSMutableArray  *parsers = [self.parsers copy];
    for (AssetBrowserParser *parser in parsers) {
        [parser cancel];
        
        NSMutableDictionary*    userInfo;
        userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishUpdateIPodLibrary
                                                            object:self
                                                          userInfo:userInfo];
        
        [self willChangeValueForKey:@"networkAccessing"];
        [self.parsers removeObject:parser];
        [self didChangeValueForKey:@"networkAccessing"];
    }
}

@end
