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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
