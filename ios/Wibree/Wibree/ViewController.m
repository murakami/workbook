//
//  ViewController.m
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/09.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "Document.h"
#import "Connector.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.myUniqueIdentifierLabel.text = [Document sharedDocument].uniqueIdentifier;
    self.yourUniqueIdentifierLabel.text = @"";
    
    __block ViewController * __weak blockWeakSelf = self;
    [[Connector sharedConnector] scanForPeripheralsWithCompletionHandler:^(WibreeCentralResponseParser *parser, NSString *uniqueIdentifier) {
        ViewController *tempSelf = blockWeakSelf;
        if (! tempSelf) return;
        
        DBGMSG(@"%s UUID(%@)", __func__, uniqueIdentifier);
        self.yourUniqueIdentifierLabel.text = uniqueIdentifier;
        
        // Local Notification
        UILocalNotification *localNotify = [[UILocalNotification alloc] init];
        localNotify.alertBody = uniqueIdentifier;
        localNotify.alertAction = @"Open";
        localNotify.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotify];
    }];
    [[Connector sharedConnector] startAdvertisingWithCompletionHandler:^(WibreePeripheralResponseParser *parser) {
        ViewController *tempSelf = blockWeakSelf;
        if (! tempSelf) return;
        
        DBGMSG(@"%s", __func__);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillAppear:animated];
    
    self.wibreeCentralSwitch.on = NO;
    self.wibreePeripheralSwitch.on = NO;
    self.beaconCentralSwitch.on = NO;
    self.beaconPeripheralSwitch.on = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [[Connector sharedConnector] cancelScan];
    [[Connector sharedConnector] cancelAdvertising];
    [[Connector sharedConnector] cancelScanForBeacons];
    [[Connector sharedConnector] cancelBeaconAdvertising];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    DBGMSG(@"%s", __func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleWibreeCentral:(id)sender
{
    DBGMSG(@"%s on(%d)", __func__, (int)self.wibreeCentralSwitch.on);
#if 0
    if (self.wibreeCentralSwitch.on) {
        __block ViewController * __weak blockWeakSelf = self;
        [[Connector sharedConnector] scanForPeripheralsWithCompletionHandler:^(WibreeCentralResponseParser *parser, NSString *uniqueIdentifier) {
            ViewController *tempSelf = blockWeakSelf;
            if (! tempSelf) return;
            
            DBGMSG(@"%s UUID(%@)", __func__, uniqueIdentifier);
            self.yourUniqueIdentifierLabel.text = uniqueIdentifier;
            
            // Local Notification
            UILocalNotification *localNotify = [[UILocalNotification alloc] init];
            localNotify.alertBody = uniqueIdentifier;
            localNotify.alertAction = @"Open";
            localNotify.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotify];
        }];
    }
    else {
        [[Connector sharedConnector] cancelScan];
    }
#endif
}

- (IBAction)toggleWibreePeripheral:(id)sender
{
    DBGMSG(@"%s on(%d)", __func__, (int)self.wibreePeripheralSwitch.on);
#if 0
    if (self.wibreePeripheralSwitch.on) {
        __block ViewController * __weak blockWeakSelf = self;
        [[Connector sharedConnector] startAdvertisingWithCompletionHandler:^(WibreePeripheralResponseParser *parser) {
            ViewController *tempSelf = blockWeakSelf;
            if (! tempSelf) return;
            
            DBGMSG(@"%s", __func__);
        }];
    }
    else {
        [[Connector sharedConnector] cancelAdvertising];
    }
#endif
}

- (IBAction)toggleBeaconCentral:(id)sender
{
    DBGMSG(@"%s on(%d)", __func__, (int)self.beaconCentralSwitch.on);
#if 0
    if (self.beaconCentralSwitch.on) {
        __block ViewController * __weak blockWeakSelf = self;
        [[Connector sharedConnector] scanForBeaconsWithCompletionHandler:^(BeaconCentralResponseParser *parser) {
            ViewController *tempSelf = blockWeakSelf;
            if (! tempSelf) return;
            
            DBGMSG(@"%s", __func__);
        } scanningHandler:^(BeaconCentralResponseParser *parser, BeaconLocationState state, NSArray *beacons, CLRegion *region) {
            ViewController *tempSelf = blockWeakSelf;
            if (! tempSelf) return;
            
            DBGMSG(@"%s state(%d)", __func__, (int)state);
            DBGMSG(@"%s beacons:%@", __func__, beacons);
            DBGMSG(@"%s region:%@", __func__, region);
            if (beacons) {
                for (CLBeacon *beacon in beacons) {
                    DBGMSG(@"%s \tbeacon:%@", __func__, beacon);
                }
            }
            
            /* CLProximityUnknown以外のビーコンだけを取り出す */
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proximity != %d", CLProximityUnknown];
            NSArray *validBeacons = [beacons filteredArrayUsingPredicate:predicate];
            DBGMSG(@"%s validBeacons:%@", __func__, validBeacons);
            DBGMSG(@"%s validFirstBeacon:%@", __func__, [validBeacons firstObject]);
        }];
    }
    else {
        [[Connector sharedConnector] cancelScanForBeacons];
    }
#endif
}

- (IBAction)toggleBeaconPeripheral:(id)sender
{
    DBGMSG(@"%s on(%d)", __func__, (int)self.beaconPeripheralSwitch.on);
#if 0
    if (self.beaconPeripheralSwitch.on) {
        __block ViewController * __weak blockWeakSelf = self;
        [[Connector sharedConnector] startBeaconAdvertisingWithCompletionHandler:^(BeaconPeripheralResponseParser *parser) {
            ViewController *tempSelf = blockWeakSelf;
            if (! tempSelf) return;
            
            DBGMSG(@"%s", __func__);
        }];
    }
    else {
        [[Connector sharedConnector] cancelBeaconAdvertising];
    }
#endif
}

@end
