//
//  Document.h
//  WayPoints
//
//  Created by 村上 幸雄 on 12/05/06.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPX/GPX.h>

@interface Document : NSObject

@property (strong, nonatomic) NSString  *version;
@property (strong, nonatomic) GPXRoot   *gpxRoot;
@property (strong, nonatomic) GPXTrack  *gpxTrack;

- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;

@end
