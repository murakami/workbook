//
//  ViewController.m
//  WayPoints
//
//  Created by 村上 幸雄 on 12/04/26.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <GPX/GPX.h>
#import "AppDelegate.h"
#import "Document.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize messageLabel = _messageLabel;
@synthesize gpxTextView = _gpxTextView;
@synthesize document = _document;
@synthesize locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate	*appl = nil;
	appl = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.document = appl.document;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    /*
    GPXRoot *root = [GPXRoot rootWithCreator:@"Sample Application"];
    
    GPXWaypoint *waypoint = [root newWaypointWithLatitude:35.658609f longitude:139.745447f];
    waypoint.name = @"Tokyo Tower";
    waypoint.comment = @"The old TV tower in Tokyo.";
    
    GPXTrack *track = [root newTrack];
    track.name = @"My New Track";
    
    GPXTrackPoint   *trkpt = nil;
    trkpt = [track newTrackpointWithLatitude:35.658609f longitude:139.745447f];
    trkpt.elevation = 0.0;
    trkpt.time = [NSDate date];
    trkpt = [track newTrackpointWithLatitude:35.758609f longitude:139.745447f];
    trkpt.elevation = 0.0;
    trkpt.time = [NSDate date];
    trkpt = [track newTrackpointWithLatitude:35.828609f longitude:139.745447f];
    trkpt.elevation = 0.0;
    trkpt.time = [NSDate date];
    
    NSLog(@"%@", root.gpx);
    */
}

- (void)viewDidUnload
{
    self.messageLabel = nil;
    self.gpxTextView = nil;
    self.document = nil;
    self.locationManager = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)trackPoint:(id)sender
{
    DBGMSG(@"%s", __func__);
    [self.locationManager startUpdatingLocation];
}

- (IBAction)dump:(id)sender
{
    NSLog(@"%@", self.document.gpxRoot.gpx);
    self.gpxTextView.text = self.document.gpxRoot.gpx;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    DBGMSG(@"%s, (%f, %f)", __func__,
           newLocation.coordinate.latitude,
           newLocation.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    
    GPXTrackPoint   *trkpt = nil;
    trkpt = [self.document.gpxTrack newTrackpointWithLatitude:newLocation.coordinate.latitude
                                                    longitude:newLocation.coordinate.longitude];
    trkpt.time = [NSDate date];
    
    NSString    *s = [[NSString alloc] initWithFormat:@"(%f, %f)",
                      newLocation.coordinate.latitude,
                      newLocation.coordinate.longitude];
    self.messageLabel.text = s;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    DBGMSG(@"%s, error:%@", __func__, [error localizedDescription]);
    [self.locationManager stopUpdatingLocation];
    
    self.messageLabel.text = [error localizedDescription];
}

@end
