//
//  BeaconCentralResponseParser.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/03/02.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "Document.h"
#import "BeaconCentralResponseParser.h"

@interface BeaconCentralResponseParser () <CLLocationManagerDelegate>
@property (assign, readwrite, nonatomic) BeaconCentralSate  state;
@property (strong, nonatomic) CLLocationManager             *locationManager;
@property (strong, nonatomic) CLBeaconRegion                *beaconRegion;
- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
@end

@implementation BeaconCentralResponseParser

#pragma mark - Lifecycle

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _state = kBeaconCentralStateUnknown;
        _error = nil;
        _delegate = nil;
        _completionHandler = nil;
        _scanningHandler = nil;
        _locationManager = nil;
        _beaconRegion = nil;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    if (self.locationManager) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    }
    
    self.state = kBeaconCentralStateUnknown;
    self.error = nil;
    self.delegate = nil;
    self.completionHandler = nil;
    self.scanningHandler = nil;
    self.locationManager = nil;
    self.beaconRegion = nil;
}

#pragma mark - ResponseParser

- (void)parse
{
    DBGMSG(@"%s", __func__);
    
    self.state = kBeaconCentralStateScanning;
    
    /* CLLocationManagerを生成 */
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if (! self.locationManager) {
        /* CLLocationManagerの初期化失敗 */
        self.state = kBeaconCentralStateError;
        self.error = [self _errorWithCode:kBeaconCentralResponseParserGenericError
                     localizedDescription:@"CLLocationManagerの初期化に失敗しました。"];
        return;
    }
    
    /* ビーコン領域を生成 */
    NSUUID  *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_SERVICE_UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"demo.Wibree.BeaconCentralResponseParser"];
    if (! self.beaconRegion) {
        /* ビーコン領域の初期化失敗 */
        self.state = kBeaconCentralStateError;
        self.error = [self _errorWithCode:kBeaconCentralResponseParserGenericError
                     localizedDescription:@"ビーコン領域の初期化に失敗しました。"];
        self.locationManager = nil;
        return;
    }
    
    /* ビーコン領域の出入りを監視 */
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    /* 距離を監視 */
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)cancel
{
    DBGMSG(@"%s", __func__);
    
    if (self.locationManager) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
        
        self.locationManager = nil;
        self.beaconRegion = nil;
    }
    self.state = kBeaconCentralStateCanceled;
    
    if ([self.delegate respondsToSelector:@selector(beaconCentralResponseParserDidCancel:)]) {
        [self.delegate beaconCentralResponseParserDidCancel:self];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    DBGMSG(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(beaconCentralResponseParser:didEnterRegion:)]) {
        [self.delegate beaconCentralResponseParser:self didEnterRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    DBGMSG(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(beaconCentralResponseParser:didExitRegion:)]) {
        [self.delegate beaconCentralResponseParser:self didExitRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    DBGMSG(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(beaconCentralResponseParser:didRangeBeacons:inRegion:)]) {
        [self.delegate beaconCentralResponseParser:self didRangeBeacons:beacons inRegion:region];
    }
}

#pragma mark - etc

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription
{
    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError         *error = [NSError errorWithDomain:@"Wibree" code:code userInfo:userInfo];
    return error;
}

@end
