//
//  ViewController.h
//  Maps
//
//  Created by 村上 幸雄 on 12/04/22.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@end
