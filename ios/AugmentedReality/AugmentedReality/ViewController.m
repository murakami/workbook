//
//  ViewController.m
//  AugmentedReality
//
//  Created by 村上 幸雄 on 13/07/09.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "ViewController.h"

#define TWEETS_UPDATE_NOTIFICATION  @"TWEETS_UPDATE_NOTIFICATION_KEY"
#define TWITTER_API_URL             @"https://api.twitter.com/1.1/search/tweets.json?geocode=%f,%f,%fkm"

@interface ViewController ()
@property (strong, nonatomic) AVCaptureSession              *capureSession;
@property (strong, nonatomic) AVCaptureDevice               *videoCaptureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput          *videoInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer    *captureVideoPreviewLayer;
@property (strong, nonatomic) CLLocationManager             *locationManager;
@property (strong, nonatomic) NSMutableData                 *downloadData;
- (AVCaptureDevice *)_cameraWithPosition:(AVCaptureDevicePosition)position;
- (AVCaptureDevice *)_frontFacingCamera;
- (AVCaptureDevice *)_backFacingCamera;
- (void)_downloadTweetAroundLat:(float)lat lng:(float)lng radius:(float)r;
@end

@implementation ViewController

@synthesize augmentedRealityView = _augmentedRealityView;
@synthesize locationLabel = _locationLabel;
@synthesize headingLabel = _headingLabel;
@synthesize capureSession = _capureSession;
@synthesize videoCaptureDevice = _videoCaptureDevice;
@synthesize videoInput = _videoInput;
@synthesize captureVideoPreviewLayer = _captureVideoPreviewLayer;
@synthesize locationManager = _locationManager;
@synthesize downloadData = _downloadData;

- (void)dealloc
{
    self.augmentedRealityView = nil;
    self.locationLabel = nil;
    self.headingLabel = nil;
    self.capureSession = nil;
    self.videoCaptureDevice = nil;
    self.videoInput = nil;
    self.captureVideoPreviewLayer = nil;
    self.locationManager = nil;
    self.downloadData = nil;
}

- (void)viewDidLoad
{
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
    
    /* Set torch and flash mode to auto */
    if ([[self _backFacingCamera] hasFlash]) {
		if ([[self _backFacingCamera] lockForConfiguration:nil]) {
			if ([[self _backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
				[[self _backFacingCamera] setFlashMode:AVCaptureFlashModeAuto];
			}
			[[self _backFacingCamera] unlockForConfiguration];
		}
	}
	if ([[self _backFacingCamera] hasTorch]) {
		if ([[self _backFacingCamera] lockForConfiguration:nil]) {
			if ([[self _backFacingCamera] isTorchModeSupported:AVCaptureTorchModeAuto]) {
				[[self _backFacingCamera] setTorchMode:AVCaptureTorchModeAuto];
			}
			[[self _backFacingCamera] unlockForConfiguration];
		}
	}
    
    /* Init the device inputs */
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self _backFacingCamera]
                                                             error:nil];
    
    /* Create session (use default AVCaptureSessionPresetHigh) */
    self.capureSession = [[AVCaptureSession alloc] init];
    
    /* Add inputs and output to the capture session */
    if ([self.capureSession canAddInput:self.videoInput]) {
        [self.capureSession addInput:self.videoInput];
    }
    
    /* Create video preview layer and add it to the UI */
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.capureSession];
    CALayer *viewLayer = [self.augmentedRealityView layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [self.augmentedRealityView bounds];
    [self.captureVideoPreviewLayer setFrame:bounds];
    DBGMSG(@"bounds(%f, %f, %f, %f)", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    
    if ([self.captureVideoPreviewLayer isOrientationSupported]) {
        [self.captureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [viewLayer insertSublayer:self.captureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.capureSession startRunning];
    });
    
    /* 現在地の更新を開始する */
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    /* 電子コンパスの測定を開始する */
    if ([CLLocationManager headingAvailable]) {
        [self.locationManager startUpdatingHeading];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillAppear:animated];
    
    //CGRect bounds = [self.augmentedRealityView bounds];
    //[self.captureVideoPreviewLayer setFrame:bounds];
    //DBGMSG(@"bounds(%f, %f, %f, %f)", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (void)viewWillLayoutSubviews
{
    DBGMSG(@"%s", __func__);
    [super viewWillLayoutSubviews];
    
    //CGRect bounds = [self.augmentedRealityView bounds];
    //[self.captureVideoPreviewLayer setFrame:bounds];
    //DBGMSG(@"bounds(%f, %f, %f, %f)", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (void)viewDidLayoutSubviews
{
    DBGMSG(@"%s", __func__);
    [super viewDidLayoutSubviews];
    
    CGRect bounds = [self.augmentedRealityView bounds];
    [self.captureVideoPreviewLayer setFrame:bounds];
    DBGMSG(@"bounds(%f, %f, %f, %f)", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    DBGMSG(@"%s", __func__);
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    DBGMSG(@"%s", __func__);
    [super didReceiveMemoryWarning];
}

- (AVCaptureDevice *)_cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)_frontFacingCamera
{
    return [self _cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)_backFacingCamera
{
    return [self _cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)_downloadTweetAroundLat:(float)lat lng:(float)lng radius:(float)r
{
    self.downloadData = [[NSMutableData alloc] init];
    
    NSString    *queryURSStr = [NSString stringWithFormat:TWITTER_API_URL, lat, lng, r];
    NSURL       *queryURL = [NSURL URLWithString:queryURSStr];
    
    /*
    NSURLRequest    *requet = [NSMutableURLRequest requestWithURL:queryURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:requet delegate:self];
    [connection start];
    */
    
    ACAccountStore  *accountStore = [[ACAccountStore alloc] init];
    ACAccountType   *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                if(granted) {
                                    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                                    
                                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                                                  @"/1.1/statuses/user_timeline.json"];
                                    NSDictionary *params = @{@"screen_name" : @"m_yukio",
                                                             @"include_rts" : @"0",
                                                             @"trim_user" : @"1",
                                                             @"count" : @"1"};
                                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                            requestMethod:SLRequestMethodGET
                                                                                      URL:url
                                                                               parameters:params];
                                    
                                    ACAccount   *twitterAccount = [accountsArray lastObject];
                                    
                                    request.account = twitterAccount;
                                    
                                    
                                    [request performRequestWithHandler:^(NSData *responseData,
                                                                         NSHTTPURLResponse *urlResponse,
                                                                         NSError *error) {
                                        if (responseData) {
                                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                                NSError *jsonError;
                                                NSDictionary *timelineData =
                                                [NSJSONSerialization
                                                 JSONObjectWithData:responseData
                                                 options:NSJSONReadingAllowFragments error:&jsonError];
                                                
                                                if (timelineData) {
                                                    NSLog(@"Timeline Response: %@\n", timelineData);
                                                }
                                                else {
                                                    // Our JSON deserialization went awry
                                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                                }
                                            }
                                            else {
                                                // The server did not respond successfully... were we rate-limited?
                                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                                            }
                                        }
                                    }];
                                }
                                else {
                                    // Access was not granted, or an error occurred
                                    NSLog(@"%@", [error localizedDescription]);
                                }
                                       }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DBGMSG(@"%s", __func__);
    CLLocation  *newLocation = [locations lastObject];
    CLLocationCoordinate2D  newCoordinate = newLocation.coordinate;
    self.locationLabel.text = [[NSString alloc] initWithFormat:@"new latitude=%.2f, longitude=%.2f", newCoordinate.latitude, newCoordinate.longitude];
    DBGMSG(@"new latitude=%f, longitude=%f", newCoordinate.latitude, newCoordinate.longitude);
    
    [self _downloadTweetAroundLat:newCoordinate.latitude lng:newCoordinate.longitude radius:0.5];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.headingLabel.text = [[NSString alloc] initWithFormat:@"trueHeading %.2f, magneticHeading %.2f", newHeading.trueHeading, newHeading.magneticHeading];
    DBGMSG(@"trueHeading %f, magneticHeading %f", newHeading.trueHeading, newHeading.magneticHeading);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.downloadData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DBGMSG(@"Network Error: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString    *resultStr = [[NSString alloc] initWithData:self.downloadData encoding:NSUTF8StringEncoding];
    DBGMSG(@"result: %@", resultStr);
    NSDictionary    *result = [NSJSONSerialization JSONObjectWithData:self.downloadData options:0 error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:TWEETS_UPDATE_NOTIFICATION object:self userInfo:nil];
}

@end
