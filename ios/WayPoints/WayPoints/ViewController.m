//
//  ViewController.m
//  WayPoints
//
//  Created by 村上 幸雄 on 12/04/26.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <GPX/GPX.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
