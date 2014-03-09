//
//  BeaconPeripheralResponseParser.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/03/02.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Document.h"
#import "BeaconPeripheralResponseParser.h"

@interface BeaconPeripheralResponseParser () <CBPeripheralManagerDelegate>
@property (assign, readwrite, nonatomic) BeaconPeripheralSate   state;
@property (strong, nonatomic) CBPeripheralManager               *peripheralManager;
@property (strong, nonatomic) CLBeaconRegion                    *beaconRegion;
- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
@end

@implementation BeaconPeripheralResponseParser

#pragma mark - Lifecycle

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _state = kBeaconPeripheralStateUnknown;
        _error = nil;
        _delegate = nil;
        _completionHandler = NULL;
        _peripheralManager = nil;
        _beaconRegion = nil;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    if (self.peripheralManager) {
        [self.peripheralManager stopAdvertising];
    }
    
    self.state = kBeaconPeripheralStateUnknown;
    self.error = nil;
    self.delegate = nil;
    self.completionHandler = NULL;
    self.peripheralManager = nil;
    self.beaconRegion = nil;
}

#pragma mark - ResponseParser

- (void)parse
{
    DBGMSG(@"%s", __func__);
    
    self.state = kBeaconPeripheralStateAdvertising;
    
    /* CBPeripheralManagerを生成 */
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if (! self.peripheralManager) {
        /* CBPeripheralManagerの初期化失敗 */
        self.state = kBeaconPeripheralStateError;
        self.error = [self _errorWithCode:kBeaconPeripheralResponseParserGenericError
                     localizedDescription:@"CBPeripheralManagerの初期化に失敗しました。"];
        return;
    }
    
    /* ビーコン領域を生成 */
    NSUUID  *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_SERVICE_UUID];
#if 1
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:12
                                                                minor:34
                                                           identifier:@"demo.Wibree.BeaconCentralResponseParser"];
#else
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:@"demo.Wibree.BeaconCentralResponseParser"];
#endif
    if (! self.beaconRegion) {
        /* ビーコン領域の初期化失敗 */
        self.state = kBeaconPeripheralStateError;
        self.error = [self _errorWithCode:kBeaconPeripheralResponseParserGenericError
                     localizedDescription:@"ビーコン領域の初期化に失敗しました。"];
        self.peripheralManager = nil;
        return;
    }
    
    /* 告知開始 */
    NSDictionary    *dictionary = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:dictionary];
}

- (void)cancel
{
    DBGMSG(@"%s", __func__);
    
    if (self.peripheralManager) {
        [self.peripheralManager stopAdvertising];
        self.peripheralManager = nil;
        self.self.beaconRegion = nil;
    }
    self.state = kBeaconPeripheralStateCanceled;
    
    if ([self.delegate respondsToSelector:@selector(beaconPeripheralResponseParserDidCancel:)]) {
        [self.delegate beaconPeripheralResponseParserDidCancel:self];
    }
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    DBGMSG( @"%s [Main=%@] state(%d)", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ", (int)peripheral.state);
}

#pragma mark - etc

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription
{
    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError         *error = [NSError errorWithDomain:@"Wibree" code:code userInfo:userInfo];
    return error;
}

@end
