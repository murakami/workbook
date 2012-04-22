//
//  ViewController.m
//  Maps
//
//  Created by 村上 幸雄 on 12/04/22.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "ViewController.h"

@interface Annotation : NSObject <MKAnnotation>
@property (strong, nonatomic) NSString                  *name;
@property (assign, nonatomic) CLLocationCoordinate2D    coordinate;
- (id)initWithName:(NSString *)name latitude:(double)latitude longitude:(double)longitude;
@end

@implementation Annotation
@synthesize name = _name;
@synthesize coordinate = _coordinate;
- (id)initWithName:(NSString *)name latitude:(double)latitude longitude:(double)longitude
{
    if ((self = [super init]) != nil) {
        CLLocationCoordinate2D    coordinate;
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;
        self.coordinate = coordinate;
        self.name = name;
    }
    return self;
}

- (NSString *)title
{
    return self.name;
}

- (void)dealloc
{
    self.name = nil;
}
@end

@interface ViewController ()
@end

@implementation ViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect  rect = CGRectMake(10.0, 80.0, 300.0, 300.0);
    self.mapView = [[MKMapView alloc] initWithFrame:rect];
    [self.view addSubview:self.mapView];
    
    MKCoordinateRegion  region = {{34.406944, 133.195462}, {1.0, 1.0}};
    [self.mapView setRegion:region animated:NO];
    
    Annotation  *annotation = [[Annotation alloc] initWithName:@"土堂小学校"
                                                     latitude:34.406944
                                                    longitude:133.195462];
    [self.mapView addAnnotation:annotation];
}

- (void)viewDidUnload
{
    self.mapView = nil;

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (pinAnnotationView == nil) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    else {
        pinAnnotationView.annotation = annotation;
    }
    
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.canShowCallout = YES;
    return pinAnnotationView;
}

@end
