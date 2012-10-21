//
//  VirtualEarthViewController.m
//  VirtualEarth
//
//  Created by 村上 幸雄 on 12/10/14.
//  Copyright (c) 2012年 Bitz Co., Ltd. All rights reserved.
//

#import "SettingsViewController.h"
#import "VirtualEarthViewController.h"

@interface VirtualEarthViewController ()
@property (nonatomic, strong) NSMutableData *data;
@end

@implementation VirtualEarthViewController

@synthesize searchBar = _searchBar;
@synthesize mapView = _mapView;
@synthesize locationBarButtonItem = _locationBarButtonItem;
@synthesize locationManager = _locationManager;
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)viewDidUnload
{
    self.searchBar = nil;
    self.mapView = nil;
    self.locationBarButtonItem = nil;
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.data = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)location:(id)sender
{
    if (self.locationBarButtonItem.style == UIBarButtonItemStyleBordered) {
        [self.locationManager startUpdatingLocation];
        self.locationBarButtonItem.style = UIBarButtonItemStyleDone;
    }
    else {
        [self.locationManager stopUpdatingLocation];
        self.locationBarButtonItem.style = UIBarButtonItemStyleBordered;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"settingsSegue"]) {
        SettingsViewController  *viewController = (SettingsViewController *)[segue destinationViewController];
        viewController.mapView = self.mapView;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation  *location = [locations lastObject];
    BMCoordinateRegion  newRegion;
    newRegion.center = location.coordinate;
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
	
    [self.mapView setRegion:newRegion animated:YES];
}

/*
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%s, searchBar.text:%@, searchText:%@", __func__, searchBar.text, searchText);
}
*/

/*
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%s, searchBar.text:%@", __func__, searchBar.text);
}
*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ((searchBar.text == nil) || (searchBar.text.length <= 0))    return;
    self.data = [[NSMutableData alloc] init];
    NSString    *bingMapsKey = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"BingMapsKey"];
    NSString    *query = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)searchBar.text,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*%'();:@&=+-$,/?%#[]~",
                                                                                     kCFStringEncodingUTF8);
    NSString    *url = [[NSString alloc] initWithFormat:@"https://dev.virtualearth.net/REST/v1/Locations?query=%@&key=%@&c=%@-%@",
                        query,
                        bingMapsKey,
                        [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                        [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    NSLog(@"url: %@", url);
    NSURLRequest    *urlRequest = nil;
    urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)aData
{
    [self.data appendData:aData];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
	return request;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error = nil;
    NSDictionary    *content = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"content:%@", content);
    
    if (content) {
        NSArray *resourceSets = [content objectForKey:@"resourceSets"];
        NSLog(@"resourceSets:%@", resourceSets);
        
        if (resourceSets) {
            NSDictionary    *resource = [resourceSets objectAtIndex:0];
            NSLog(@"resource:%@", resource);
            
            if (resource) {
                NSArray    *resources = [resource objectForKey:@"resources"];
                NSLog(@"resources:%@", resources);
                
                if ((resources) && (0 < [resources count])) {
                    resource = [resources objectAtIndex:0];
                    NSLog(@"resource:%@", resource);
                    
                    if (resource) {
                        NSDictionary    *point = [resource objectForKey:@"point"];
                        NSLog(@"point:%@", point);
                        
                        if (point) {
                            NSArray *coordinates = [point objectForKey:@"coordinates"];
                            NSLog(@"coordinates:%@", coordinates);
                            
                            if ((coordinates) && (0 < [coordinates count])) {
                                NSString    *latitude = [coordinates objectAtIndex:0];
                                NSString    *longitude = [coordinates objectAtIndex:1];
                                NSLog(@"latitude:%@", latitude);
                                NSLog(@"longitude:%@", longitude);
                                
                                if ((latitude) && (longitude)) {
                                    BMCoordinateRegion  newRegion;
                                    newRegion.center.latitude = [latitude floatValue];
                                    newRegion.center.longitude = [longitude floatValue];
                                    newRegion.span.latitudeDelta = 0.005;
                                    newRegion.span.longitudeDelta = 0.005;
                                    
                                    [self.mapView setRegion:newRegion animated:YES];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    if ([self.searchBar canResignFirstResponder])
        [self.searchBar resignFirstResponder];
}

@end
