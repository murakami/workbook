//
//  Connector.h
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WibreeCentralResponseParser.h"
#import "WibreePeripheralResponseParser.h"

extern NSString *ConnectorDidBeginWibreeCentral;
extern NSString *ConnectorDidDiscoverUUID;
extern NSString *ConnectorDidFinishWibreeCentral;
extern NSString *ConnectorDidBeginWibreePeripheral;
extern NSString *ConnectorDidFinishWibreePeripheral;
extern NSString *ConnectorDidFinishAll;

@interface Connector : NSObject

@property (assign, readonly, nonatomic, getter=isNetworkAccessing) BOOL networkAccessing;

+ (Connector *)sharedConnector;
- (void)scanForPeripheralsWithCompletionHandler:(WibreeCentralResponseParserCompletionHandler)completionHandler;
- (void)cancelScan;
- (void)startAdvertisingWithCompletionHandler:(WibreePeripheralResponseParserCompletionHandler)completionHandler;
- (void)cancelAdvertising;
- (void)cancelAll;

@end
