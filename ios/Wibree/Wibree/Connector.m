//
//  Connector.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "Connector.h"

NSString    *ConnectorDidBeginWibreeCentral = @"ConnectorDidBeginWibreeCentral";
NSString    *ConnectorDidDiscoverUUID = @"ConnectorDidDiscoverUUID";
NSString    *ConnectorDidFinishWibreeCentral = @"ConnectorDidFinishWibreeCentral";
NSString    *ConnectorDidBeginWibreePeripheral = @"ConnectorDidBeginWibreePeripheral";
NSString    *ConnectorDidFinishWibreePeripheral = @"ConnectorDidFinishWibreePeripheral";
NSString    *ConnectorDidBeginBeaconCentral = @"ConnectorDidBeginBeaconCentral";
NSString    *ConnectorDidEnterRegion = @"ConnectorDidEnterRegion";
NSString    *ConnectorDidExitRegion = @"ConnectorDidExitRegion";
NSString    *ConnectorDidRangeBeaconsInRegion = @"ConnectorDidRangeBeaconsInRegion";
NSString    *ConnectorDidFinishBeaconCentral = @"ConnectorDidFinishBeaconCentral";
NSString    *ConnectorDidBeginBeaconPeripheral = @"ConnectorDidBeginBeaconPeripheral";
NSString    *ConnectorDidFinishBeaconPeripheral = @"ConnectorDidFinishBeaconPeripheral";
NSString    *ConnectorDidFinishAll = @"ConnectorDidFinishAll";

@interface Connector () <WibreeCentralResponseParserDelegate, WibreePeripheralResponseParserDelegate,
                        BeaconCentralResponseParserDelegate, BeaconPeripheralResponseParserDelegate>
@property (strong, nonatomic) NSMutableArray    *parsers;
- (void)_notifyWibreeCentralStatusWithParser:(WibreeCentralResponseParser *)parser uuid:(NSString *)uniqueIdentifier;
- (void)_notifyWibreePeripheralStatusWithParser:(WibreePeripheralResponseParser *)parser;
- (void)_notifyBeaconCentralStatusWithParser:(BeaconCentralResponseParser *)parser;
- (void)_notifyBeaconCentralStatusWithParser:(BeaconCentralResponseParser *)parser
                                       state:(BeaconLocationState)state
                                     beacons:(NSArray *)beacons
                                      region:(CLRegion *)region;
- (void)_notifyBeaconPeripheralStatusWithParser:(BeaconPeripheralResponseParser *)parser;
@end

@implementation Connector

@synthesize parsers = _parsers;

+ (Connector *)sharedConnector
{
    static Connector *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Connector alloc] init];
    });
	return _sharedInstance;
}

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _parsers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.parsers = nil;
}

- (BOOL)isNetworkAccessing
{
    return NO;
}

- (void)scanForPeripheralsWithCompletionHandler:(WibreeCentralResponseParserCompletionHandler)completionHandler
{
    DBGMSG(@"%s", __func__);
    
    /* パーサのインスタンスを生成 */
    WibreeCentralResponseParser *parser = [[WibreeCentralResponseParser alloc] init];
    parser.delegate = self;
    parser.completionHandler = completionHandler;
    
    /* 処理開始 */
    [parser parse];
    if (parser.error) {
        /* 処理開始エラー */
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishWibreeCentral
                                                            object:self
                                                          userInfo:userInfo];
        if (parser.completionHandler) {
            parser.completionHandler(parser, nil);
        }
        return;
    }
    
    /* 処理中パーサを配列に格納 */
    [self.parsers addObject:parser];
    
    /* 処理開始を通知 */
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidBeginWibreeCentral
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)cancelScan
{
    DBGMSG(@"%s", __func__);
    NSArray *parsers = [self.parsers copy];
    for (id parser in parsers) {
        if ([parser isKindOfClass:[WibreeCentralResponseParser class]]) {
            [parser cancel];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:parser forKey:@"parser"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishWibreeCentral
                                                                object:self
                                                              userInfo:userInfo];
            [self.parsers removeObject:parser];
        }
    }
}

- (void)wibreeCentralResponseParser:(WibreeCentralResponseParser *)parser didDiscoverUUID:(NSString *)uniqueIdentifier
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyWibreeCentralStatusWithParser:parser uuid:uniqueIdentifier];
    }
}

- (void)wibreeCentralResponseParserDidCancel:(WibreeCentralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyWibreeCentralStatusWithParser:parser uuid:nil];
    }
}

- (void)_notifyWibreeCentralStatusWithParser:(WibreeCentralResponseParser *)parser uuid:(NSString *)uniqueIdentifier
{
    DBGMSG(@"%s", __func__);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    if (uniqueIdentifier) {
        [userInfo setObject:uniqueIdentifier forKey:@"uniqueIdentifier"];
    }
    else {
        [userInfo setObject:[NSNull null] forKey:@"uniqueIdentifier"];
    }
    
    /* 通信結果を通知（通知センター） */
    NSString    *notifyName = ConnectorDidDiscoverUUID;
    if ((parser.state == kWibreeCentralStateError) || (parser.state == kWibreeCentralStateCanceled)) {
        notifyName = ConnectorDidFinishWibreeCentral;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName
                                                        object:self
                                                      userInfo:userInfo];
    /* 通信結果を通知（Blocks） */
    if (parser.completionHandler) {
        parser.completionHandler(parser, uniqueIdentifier);
    }
    
    if ((parser.state == kWibreeCentralStateError) || (parser.state == kWibreeCentralStateCanceled)) {
        [self.parsers removeObject:parser];
    }
}

- (void)startAdvertisingWithCompletionHandler:(WibreePeripheralResponseParserCompletionHandler)completionHandler
{
    DBGMSG(@"%s", __func__);
    
    /* パーサのインスタンスを生成 */
    WibreePeripheralResponseParser *parser = [[WibreePeripheralResponseParser alloc] init];
    parser.delegate = self;
    parser.completionHandler = completionHandler;
    
    /* 処理開始 */
    [parser parse];
    if (parser.error) {
        /* 処理開始エラー */
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishWibreePeripheral
                                                            object:self
                                                          userInfo:userInfo];
        if (parser.completionHandler) {
            parser.completionHandler(parser);
        }
        return;
    }
    
    /* 処理中パーサを配列に格納 */
    [self.parsers addObject:parser];
    
    /* 処理開始を通知 */
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidBeginWibreePeripheral
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)cancelAdvertising
{
    DBGMSG(@"%s", __func__);
    NSArray *parsers = [self.parsers copy];
    for (id parser in parsers) {
        if ([parser isKindOfClass:[WibreePeripheralResponseParser class]]) {
            [parser cancel];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:parser forKey:@"parser"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishWibreePeripheral
                                                                object:self
                                                              userInfo:userInfo];
            [self.parsers removeObject:parser];
        }
    }
}

- (void)wibreePeripheralResponseParser:(WibreePeripheralResponseParser *)parser didFailWithError:(NSError*)error
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyWibreePeripheralStatusWithParser:parser];
    }
}

- (void)wibreePeripheralResponseParserDidCancel:(WibreePeripheralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyWibreePeripheralStatusWithParser:parser];
    }
}

- (void)_notifyWibreePeripheralStatusWithParser:(WibreePeripheralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    /* 通信完了を通知（通知センター） */
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishWibreePeripheral
                                                        object:self
                                                      userInfo:userInfo];
    /* 通信完了を通知（Blocks） */
    if (parser.completionHandler) {
        parser.completionHandler(parser);
    }
    
    [self.parsers removeObject:parser];
}

- (void)scanForBeaconsWithCompletionHandler:(BeaconCentralResponseParserCompletionHandler)completionHandler
                            scanningHandler:(BeaconCentralResponseParserScanningHandler)scanningHandler
{
    DBGMSG(@"%s", __func__);
    
    /* パーサのインスタンスを生成 */
    BeaconCentralResponseParser *parser = [[BeaconCentralResponseParser alloc] init];
    parser.delegate = self;
    parser.completionHandler = completionHandler;
    parser.scanningHandler = scanningHandler;
    
    /* 処理開始 */
    [parser parse];
    if (parser.error) {
        /* 処理開始エラー */
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishBeaconCentral
                                                            object:self
                                                          userInfo:userInfo];
        if (parser.completionHandler) {
            parser.completionHandler(parser);
        }
        return;
    }
    
    /* 処理中パーサを配列に格納 */
    [self.parsers addObject:parser];
    
    /* 処理開始を通知 */
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidBeginBeaconCentral
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)cancelScanForBeacons
{
    DBGMSG(@"%s", __func__);
    NSArray *parsers = [self.parsers copy];
    for (id parser in parsers) {
        if ([parser isKindOfClass:[BeaconCentralResponseParser class]]) {
            [parser cancel];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:parser forKey:@"parser"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishBeaconCentral
                                                                object:self
                                                              userInfo:userInfo];
            [self.parsers removeObject:parser];
        }
    }
}

- (void)beaconCentralResponseParser:(BeaconCentralResponseParser *)parser
                     didEnterRegion:(CLRegion *)region
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyBeaconCentralStatusWithParser:parser
                                             state:kBeaconLocationStateDidEnterRegion
                                           beacons:nil
                                            region:region];
    }
}

- (void)beaconCentralResponseParser:(BeaconCentralResponseParser *)parser
                      didExitRegion:(CLRegion *)region
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyBeaconCentralStatusWithParser:parser
                                             state:kBeaconLocationStateDidExitRegion
                                           beacons:nil
                                            region:region];
    }
}

- (void)beaconCentralResponseParser:(BeaconCentralResponseParser *)parser
                    didRangeBeacons:(NSArray *)beacons
                           inRegion:(CLBeaconRegion *)region
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyBeaconCentralStatusWithParser:parser
                                             state:kBeaconLocationStateDidRangeBeaconsInRegion
                                           beacons:beacons
                                            region:region];
    }
}

- (void)beaconCentralResponseParserDidCancel:(BeaconCentralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyBeaconCentralStatusWithParser:parser];
    }
}

- (void)_notifyBeaconCentralStatusWithParser:(BeaconCentralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    /* 通信結果を通知（通知センター） */
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishBeaconCentral
                                                        object:self
                                                      userInfo:userInfo];
    /* 通信結果を通知（Blocks） */
    if (parser.completionHandler) {
        parser.completionHandler(parser);
    }
    
    [self.parsers removeObject:parser];
}

- (void)_notifyBeaconCentralStatusWithParser:(BeaconCentralResponseParser *)parser
                                       state:(BeaconLocationState)state
                                     beacons:(NSArray *)beacons
                                      region:(CLRegion *)region
{
    DBGMSG(@"%s", __func__);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    /* 通信結果を通知（通知センター） */
    NSString    *notifyName = ConnectorDidEnterRegion;
    if (state == kBeaconLocationStateDidEnterRegion) {
        notifyName = ConnectorDidEnterRegion;
    }
    else if (state == kBeaconLocationStateDidExitRegion) {
        notifyName = ConnectorDidExitRegion;
    }
    else if (state == kBeaconLocationStateDidRangeBeaconsInRegion) {
        notifyName = ConnectorDidRangeBeaconsInRegion;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName
                                                        object:self
                                                      userInfo:userInfo];
    /* 通信結果を通知（Blocks） */
    if (parser.scanningHandler) {
        parser.scanningHandler(parser, state, beacons, region);
    }
}

- (void)startBeaconAdvertisingWithCompletionHandler:(BeaconPeripheralResponseParserCompletionHandler)completionHandler
{
    DBGMSG(@"%s", __func__);
    
    /* パーサのインスタンスを生成 */
    BeaconPeripheralResponseParser *parser = [[BeaconPeripheralResponseParser alloc] init];
    parser.delegate = self;
    parser.completionHandler = completionHandler;
    
    /* 処理開始 */
    [parser parse];
    if (parser.error) {
        /* 処理開始エラー */
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:parser forKey:@"parser"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishBeaconPeripheral
                                                            object:self
                                                          userInfo:userInfo];
        if (parser.completionHandler) {
            parser.completionHandler(parser);
        }
        return;
    }
    
    /* 処理中パーサを配列に格納 */
    [self.parsers addObject:parser];
    
    /* 処理開始を通知 */
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidBeginBeaconPeripheral
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)cancelBeaconAdvertising
{
    DBGMSG(@"%s", __func__);
    NSArray *parsers = [self.parsers copy];
    for (id parser in parsers) {
        if ([parser isKindOfClass:[BeaconPeripheralResponseParser class]]) {
            [parser cancel];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:parser forKey:@"parser"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishBeaconPeripheral
                                                                object:self
                                                              userInfo:userInfo];
            [self.parsers removeObject:parser];
        }
    }
}

- (void)beaconPeripheralResponseParser:(BeaconPeripheralResponseParser *)parser didFailWithError:(NSError*)error
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyBeaconPeripheralStatusWithParser:parser];
    }
}

- (void)beaconPeripheralResponseParserDidCancel:(BeaconPeripheralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    if ([self.parsers containsObject:parser]) {
        [self _notifyBeaconPeripheralStatusWithParser:parser];
    }
}

- (void)_notifyBeaconPeripheralStatusWithParser:(BeaconPeripheralResponseParser *)parser
{
    DBGMSG(@"%s", __func__);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:parser forKey:@"parser"];
    
    /* 通信完了を通知（通知センター） */
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishBeaconPeripheral
                                                        object:self
                                                      userInfo:userInfo];
    /* 通信完了を通知（Blocks） */
    if (parser.completionHandler) {
        parser.completionHandler(parser);
    }
    
    [self.parsers removeObject:parser];
}

- (void)cancelAll
{
    DBGMSG(@"%s", __func__);
    for (id parser in self.parsers) {
        [parser cancel];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.parsers forKey:@"parsers"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectorDidFinishAll
                                                        object:self
                                                      userInfo:userInfo];
    [self.parsers removeAllObjects];
}

@end
