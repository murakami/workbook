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

@interface VirtualEarthViewController : UIViewController <BMMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet BMMapView  *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
