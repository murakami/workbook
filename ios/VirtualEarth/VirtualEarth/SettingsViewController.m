//
//  SettingsViewController.m
//  VirtualEarth
//
//  Created by 村上 幸雄 on 12/10/22.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@end

@implementation SettingsViewController

@synthesize mapModeSegmentedControl = _mapModeSegmentedControl;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.mapModeSegmentedControl = nil;
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mapView.mapMode == BMMapModeRoad)
        self.mapModeSegmentedControl.selectedSegmentIndex = 0;
    else if (self.mapView.mapMode == BMMapModeAerial)
        self.mapModeSegmentedControl.selectedSegmentIndex = 1;
    else if (self.mapView.mapMode == BMMapModeAerialWithLabels)
        self.mapModeSegmentedControl.selectedSegmentIndex = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)mapMode:(id)sender
{
    UISegmentedControl  *mapModeSegmentedControl = sender;
    switch (mapModeSegmentedControl.selectedSegmentIndex) {
        case BMMapModeRoad:
            self.mapView.mapMode = BMMapModeRoad;
            break;
        case BMMapModeAerial:
            self.mapView.mapMode = BMMapModeAerial;
            break;
        case BMMapModeAerialWithLabels:
            self.mapView.mapMode = BMMapModeAerialWithLabels;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
                    }
                    completion:nil];
    */
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

@end
