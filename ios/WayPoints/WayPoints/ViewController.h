//
//  ViewController.h
//  WayPoints
//
//  Created by 村上 幸雄 on 12/04/26.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Document;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel      *messageLabel;
@property (strong, nonatomic) IBOutlet UITextView   *gpxTextView;
@property (strong, nonatomic) Document              *document;
@property (strong, nonatomic) CLLocationManager     *locationManager;
@property (strong, nonatomic) CLGeocoder            *geocoder;

- (IBAction)trackPoint:(id)sender;
- (IBAction)dump:(id)sender;

@end
