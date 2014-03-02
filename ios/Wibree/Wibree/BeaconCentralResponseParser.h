//
//  BeaconCentralResponseParser.h
//  Wibree
//
//  Created by 村上幸雄 on 2014/03/02.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class BeaconCentralResponseParser;

#define kBeaconCentralResponseParserNoError        0
#define kBeaconCentralResponseParserGenericError   1

typedef enum _BeaconCentralState {
    kBeaconCentralStateUnknown = 0,
    kBeaconCentralStateScanning,
    kBeaconCentralStateError,
    kBeaconCentralStateCanceled
} BeaconCentralSate;

typedef enum _BeaconLocationState {
    kBeaconLocationStateDidEnterRegion = 0,
    kBeaconLocationStateDidExitRegion,
    kBeaconLocationStateDidRangeBeaconsInRegion
} BeaconLocationState;

typedef void (^BeaconCentralResponseParserCompletionHandler)(BeaconCentralResponseParser *parser);
typedef void (^BeaconCentralResponseParserScanningHandler)(BeaconCentralResponseParser *parser, BeaconLocationState state, NSArray *beacons, CLRegion *region);

@protocol BeaconCentralResponseParserDelegate <NSObject>
- (void)beaconCentralResponseParser:(BeaconCentralResponseParser *)parser didEnterRegion:(CLRegion *)region;
- (void)beaconCentralResponseParser:(BeaconCentralResponseParser *)parser didExitRegion:(CLRegion *)region;
- (void)beaconCentralResponseParser:(BeaconCentralResponseParser *)parser didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (void)beaconCentralResponseParserDidCancel:(BeaconCentralResponseParser *)parser;
@end

@interface BeaconCentralResponseParser : NSObject

@property (assign, readonly, nonatomic) BeaconCentralSate                   state;
@property (strong, nonatomic) NSError                                       *error;
@property (weak, nonatomic) id<BeaconCentralResponseParserDelegate>         delegate;
@property (copy, nonatomic) BeaconCentralResponseParserCompletionHandler    completionHandler;
@property (copy, nonatomic) BeaconCentralResponseParserScanningHandler      scanningHandler;

- (void)parse;
- (void)cancel;

@end
