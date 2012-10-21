//
//  SettingsViewController.h
//  VirtualEarth
//
//  Created by 村上 幸雄 on 12/10/22.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingMaps/BingMaps.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapModeSegmentedControl;
@property (strong, nonatomic) BMMapView                 *mapView;

- (IBAction)mapMode:(id)sender;

@end
