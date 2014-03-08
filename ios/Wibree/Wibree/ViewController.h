//
//  ViewController.h
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/09.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *myUniqueIdentifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourUniqueIdentifierLabel;
@property (weak, nonatomic) IBOutlet UISwitch   *wibreeCentralSwitch;
@property (weak, nonatomic) IBOutlet UISwitch   *wibreePeripheralSwitch;
@property (weak, nonatomic) IBOutlet UISwitch   *beaconCentralSwitch;
@property (weak, nonatomic) IBOutlet UISwitch   *beaconPeripheralSwitch;

- (IBAction)toggleWibreeCentral:(id)sender;
- (IBAction)toggleWibreePeripheral:(id)sender;
- (IBAction)toggleBeaconCentral:(id)sender;
- (IBAction)toggleBeaconPeripheral:(id)sender;

@end
