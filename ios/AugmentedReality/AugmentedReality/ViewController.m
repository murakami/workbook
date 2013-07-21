//
//  ViewController.m
//  AugmentedReality
//
//  Created by 村上 幸雄 on 13/07/09.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) AVCaptureSession              *capureSession;
@property (strong, nonatomic) AVCaptureDevice               *videoCaptureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput          *videoInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer    *captureVideoPreviewLayer;
@property (strong, nonatomic) CLLocationManager             *locationManager;
- (AVCaptureDevice *)_cameraWithPosition:(AVCaptureDevicePosition)position;
- (AVCaptureDevice *)_frontFacingCamera;
- (AVCaptureDevice *)_backFacingCamera;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DBGMSG(@"%s", __func__);
    CLLocation  *newLocation = [locations lastObject];
    CLLocationCoordinate2D  newCoordinate = newLocation.coordinate;
    self.locationLabel.text = [[NSString alloc] initWithFormat:@"new latitude=%.2f, longitude=%.2f", newCoordinate.latitude, newCoordinate.longitude];
    DBGMSG(@"new latitude=%f, longitude=%f", newCoordinate.latitude, newCoordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.headingLabel.text = [[NSString alloc] initWithFormat:@"trueHeading %.2f, magneticHeading %.2f", newHeading.trueHeading, newHeading.magneticHeading];
    DBGMSG(@"trueHeading %f, magneticHeading %f", newHeading.trueHeading, newHeading.magneticHeading);
}

@end
