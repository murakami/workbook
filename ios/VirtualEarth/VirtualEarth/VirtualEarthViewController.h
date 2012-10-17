//
//  VirtualEarthViewController.h
//  VirtualEarth
//
//  Created by 村上 幸雄 on 12/10/14.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "BingMaps/BingMaps.h"

@interface VirtualEarthViewController : UIViewController
    <BMMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UISearchBar        *searchBar;
@property (nonatomic, weak) IBOutlet BMMapView          *mapView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *locationBarButtonItem;
@property (nonatomic, strong) CLLocationManager         *locationManager;

- (IBAction)location:(id)sender;
@end
