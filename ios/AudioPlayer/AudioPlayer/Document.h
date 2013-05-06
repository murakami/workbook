//
//  Document.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/06.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject
@property (strong, nonatomic) NSString  *version;
+ (Document *)sharedInstance;
- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;
@end
