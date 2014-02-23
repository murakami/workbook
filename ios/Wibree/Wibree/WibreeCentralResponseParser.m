//
//  WibreeResponseParser.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "Document.h"
#import "WibreeCentralResponseParser.h"

@interface WibreeCentralResponseParser () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (assign, readwrite, nonatomic) WibreeCentralSate  state;
@property (strong, nonatomic) CBCentralManager              *centralManager;
@property (strong, nonatomic) CBPeripheral                  *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData                 *data;
- (void)_notifyParserDidDiscoverUUID:(NSString *)uniqueIdentifier;
- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
@end

@implementation WibreeCentralResponseParser

#pragma mark - Lifecycle

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _state = kWibreeCentralStateUnknown;
        _error = nil;
        _delegate = nil;
        _completionHandler = NULL;
        _centralManager = nil;
        _discoveredPeripheral = nil;
        _data = nil;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    
    if (self.centralManager) {
        // Don't keep it going while we're not showing.
        [self.centralManager stopScan];
        DBGMSG(@"Scanning stopped");
    }
    
    self.state = kWibreeCentralStateUnknown;
    self.error = nil;
    self.delegate = nil;
    self.completionHandler = NULL;
    self.centralManager = nil;
    self.discoveredPeripheral = nil;
    self.data = nil;
}

#pragma mark - ResponseParser

- (void)parse
{
    DBGMSG(@"%s", __func__);
    
    self.state = kWibreeCentralStateScanning;
    
    // Start up the CBCentralManager
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if (! self.centralManager) {
        /* CBCentralManagerの初期化失敗 */
        self.state = kWibreeCentralStateError;
        self.error = [self _errorWithCode:kWibreeCentralResponseParserGenericError
                     localizedDescription:@"CBCentralManagerの初期化に失敗しました。"];
        return;
    }
    
    // And somewhere to store the incoming data
    self.data = [[NSMutableData alloc] init];
}

- (void)cancel
{
    DBGMSG(@"%s", __func__);
    
    if (self.centralManager) {
        // Don't keep it going while we're not showing.
        [self.centralManager stopScan];
        DBGMSG(@"Scanning stopped");
        
        self.centralManager = nil;
    }
    self.data = nil;
    self.state = kWibreeCentralStateCanceled;
    
    if ([self.delegate respondsToSelector:@selector(wibreeCentralResponseParserDidCancel:)]) {
        [self.delegate wibreeCentralResponseParserDidCancel:self];
    }
}

- (void)_notifyParserDidDiscoverUUID:(NSString *)uniqueIdentifier
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    /* デリゲートに通知 */
    if ([self.delegate respondsToSelector:@selector(wibreeCentralResponseParser:didDiscoverUUID:)]) {
        [self.delegate wibreeCentralResponseParser:self
                                   didDiscoverUUID:uniqueIdentifier];
    }
}

#pragma mark - Central Methods

/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    DBGMSG(@"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    if (central.state != CBCentralManagerStatePoweredOn) {
        DBGMSG(@"%s In a real app, you'd deal with all the states correctly", __func__);
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    [self scan];
    
}

/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:WIBREE_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    DBGMSG(@"Scanning started");
}

/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    //DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    if (RSSI.integerValue > -15) {
        DBGMSG(@"%s Reject any where the value is above reasonable range", __func__);
        return;
    }
    
    if (RSSI.integerValue < -35) {
        DBGMSG(@"%s Reject if the signal strength is too low to be close enough (Close is around -22dB)", __func__);
        return;
    }
    
    DBGMSG(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    // Ok, it's in range - have we already seen it?
    if (self.discoveredPeripheral != peripheral) {
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        DBGMSG(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    DBGMSG(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}

/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    DBGMSG(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    DBGMSG(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:WIBREE_SERVICE_UUID]]];
}

/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    if (error) {
        DBGMSG(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:WIBREE_CHARACTERISTIC_UUID]] forService:service];
    }
}

/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    // Deal with errors (if any)
    if (error) {
        DBGMSG(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WIBREE_CHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}

/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    if (error) {
        DBGMSG(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // We have, so show the data,
        NSString    *uniqueIdentifier = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        DBGMSG(@"%s UUID(%@)", __func__, uniqueIdentifier);
        /* 主スレッドで実行させる */
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _notifyParserDidDiscoverUUID:uniqueIdentifier];
        });
        
        // Cancel our subscription to the characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    
    // Otherwise, just add the data on to what we already have
    [self.data appendData:characteristic.value];
    
    // Log it
    DBGMSG(@"Received: %@", stringFromData);
}

// RSSIの情報がアップデートされた
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    DBGMSG(@"%s [Main=%@] RSSI%@,%d", __func__, [NSThread isMainThread] ? @"YES" : @"NO ", peripheral.RSSI, peripheral.state);
}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    if (error) {
        DBGMSG(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:WIBREE_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        DBGMSG(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        DBGMSG(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    DBGMSG(@"%s [Main=%@] Peripheral Disconnected", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    self.discoveredPeripheral = nil;
    
    // We're disconnected, so start scanning again
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scan];
    });
}

/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    // Don't do anything if we're not connected
    /* if (!self.discoveredPeripheral.isConnected) { */
    /*
    BOOL    isConnected = NO;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        isConnected = self.discoveredPeripheral.isConnected;
    }
    else {
        isConnected = (self.discoveredPeripheral.state == CBPeripheralStateConnected) ? YES : NO;
    }
     if (! isConnected) {
    */
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WIBREE_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

#pragma mark - etc

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription
{
    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError         *error = [NSError errorWithDomain:@"Wibree" code:code userInfo:userInfo];
    return error;
}

@end
