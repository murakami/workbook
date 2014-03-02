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
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidAppear:animated];
    
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
    
#if 0
    [[Connector sharedConnector] scanForBeaconsWithCompletionHandler:^(BeaconCentralResponseParser *parser) {
        ViewController *tempSelf = blockWeakSelf;
        if (! tempSelf) return;
        
        DBGMSG(@"%s", __func__);
    } scanningHandler:^(BeaconCentralResponseParser *parser, BeaconLocationState state, NSArray *beacons, CLRegion *region) {
        ViewController *tempSelf = blockWeakSelf;
        if (! tempSelf) return;

        //if ((state == kBeaconLocationStateDidEnterRegion) || (state == kBeaconLocationStateDidExitRegion)) {
            DBGMSG(@"%s state(%d)", __func__, (int)state);
            DBGMSG(@"%s beacons:%@", __func__, beacons);
            DBGMSG(@"%s region:%@", __func__, region);
        //}
    }];
    
    [[Connector sharedConnector] startBeaconAdvertisingWithCompletionHandler:^(BeaconPeripheralResponseParser *parser) {
        ViewController *tempSelf = blockWeakSelf;
        if (! tempSelf) return;
        
        DBGMSG(@"%s", __func__);
    }];
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [[Connector sharedConnector] cancelScan];
    [[Connector sharedConnector] cancelAdvertising];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    DBGMSG(@"%s", __func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
