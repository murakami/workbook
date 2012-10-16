//
//  VirtualEarthViewController.m
//  VirtualEarth
//
//  Created by 村上 幸雄 on 12/10/14.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "VirtualEarthViewController.h"

@interface VirtualEarthViewController ()
@end

@implementation VirtualEarthViewController

@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation  *location = [locations lastObject];
    BMCoordinateRegion  newRegion;
    newRegion.center = location.coordinate;
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
	
    [self.mapView setRegion:newRegion animated:YES];

    [self.locationManager stopUpdatingLocation];
}

@end
