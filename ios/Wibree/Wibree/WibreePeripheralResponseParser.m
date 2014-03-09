//
//  WibreePeripheralResponseParser.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "Document.h"
#import "WibreePeripheralResponseParser.h"

#define NOTIFY_MTU                  20

@interface WibreePeripheralResponseParser () <CBPeripheralManagerDelegate>
@property (assign, readwrite, nonatomic) WibreePeripheralSate   state;
@property (strong, nonatomic) CBPeripheralManager               *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic           *transferCharacteristic;
@property (strong, nonatomic) NSData                            *dataToSend;
@property (nonatomic, readwrite) NSInteger                      sendDataIndex;

- (void)_notifyParserDidFailWithError:(NSError*)error;
- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
@end

@implementation WibreePeripheralResponseParser

#pragma mark - Lifecycle

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _state = kWibreePeripheralStateUnknown;
        _error = nil;
        _delegate = nil;
        _completionHandler = NULL;
        _peripheralManager = nil;
        _transferCharacteristic = nil;
        _dataToSend = nil;
        _sendDataIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    
    if (self.peripheralManager) {
        // Don't keep it going while we're not showing.
        [self.peripheralManager stopAdvertising];
    }
    
    self.state = kWibreePeripheralStateUnknown;
    self.error = nil;
    self.delegate = nil;
    self.completionHandler = NULL;
    self.peripheralManager = nil;
    self.transferCharacteristic = nil;
    self.dataToSend = nil;
    self.sendDataIndex = 0;
}

#pragma mark - ResponseParser

- (void)parse
{
    DBGMSG(@"%s", __func__);
    
    self.state = kWibreePeripheralStateAdvertising;
    
    // Start up the CBPeripheralManager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if (! self.peripheralManager) {
        /* CBPeripheralManagerの初期化失敗 */
        self.state = kWibreePeripheralStateError;
        self.error = [self _errorWithCode:kWibreePeripheralResponseParserGenericError
                     localizedDescription:@"CBPeripheralManagerの初期化に失敗しました。"];
        return;
    }
    
    // All we advertise is our service's UUID
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:WIBREE_SERVICE_UUID]] }];
}

- (void)cancel
{
    DBGMSG(@"%s", __func__);
    
    if (self.peripheralManager) {
        // Don't keep it going while we're not showing.
        [self.peripheralManager stopAdvertising];
        
        self.peripheralManager = nil;
    }
    self.transferCharacteristic = nil;
    self.dataToSend = nil;
    self.sendDataIndex = 0;
    self.state = kWibreePeripheralStateCanceled;
    
    if ([self.delegate respondsToSelector:@selector(wibreePeripheralResponseParserDidCancel:)]) {
        [self.delegate wibreePeripheralResponseParserDidCancel:self];
    }
}

- (void)_notifyParserDidFailWithError:(NSError*)error
{
    DBGMSG( @"%s [Main=%@]", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ");
    /* デリゲートに通知 */
    if ([self.delegate respondsToSelector:@selector(wibreePeripheralResponseParser:didFailWithError:)]) {
        [self.delegate wibreePeripheralResponseParser:self didFailWithError:error];
    }
}

#pragma mark - Peripheral Methods

/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    DBGMSG(@"%s", __func__);
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        DBGMSG(@"%s state(%d) not power on", __func__, (int)peripheral.state);
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    DBGMSG(@"%s self.peripheralManager powered on.", __func__);
    
    // ... so build our service.
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:WIBREE_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:WIBREE_SERVICE_UUID]
                                                                       primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
}

/** Catch when someone subscribes to our characteristic, then start sending them data
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    DBGMSG(@"%s Central subscribed to characteristic", __func__);
    
    // Get the data
    self.dataToSend = [[Document sharedDocument].uniqueIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    
    // Reset the index
    self.sendDataIndex = 0;
    
    // Start sending
    [self sendData];
}

/** Recognise when the central unsubscribes
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    DBGMSG(@"Central unsubscribed from characteristic");
}

/** Sends the next amount of data to the connected central
 */
- (void)sendData
{
    DBGMSG(@"%s", __func__);
    // First up, check if we're meant to be sending an EOM
    static BOOL sendingEOM = NO;
    
    if (sendingEOM) {
        
        // send it
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // Did it send?
        if (didSend) {
            
            // It did, so mark it as sent
            sendingEOM = NO;
            
            DBGMSG(@"Sent: EOM");
        }
        
        // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    
    // We're not sending an EOM, so we're sending data
    
    // Is there any left to send?
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        
        // No data left.  Do nothing
        return;
    }
    
    // There's data left, so send until the callback fails, or we're done.
    
    BOOL didSend = YES;
    
    while (didSend) {
        
        // Make the next chunk
        
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        
        // Send it
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        DBGMSG(@"Sent: %@", stringFromData);
        
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // It was - send an EOM
            
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            
            // Send it
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                
                DBGMSG(@"Sent: EOM");
            }
            
            return;
        }
    }
}

/** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
 *  This is to ensure that packets will arrive in the order they are sent
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    DBGMSG(@"%s", __func__);
    // Start sending again
    [self sendData];
}

#pragma mark - etc

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription
{
    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError         *error = [NSError errorWithDomain:@"Wibree" code:code userInfo:userInfo];
    return error;
}

@end
