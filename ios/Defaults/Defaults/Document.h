//
//  Document.h
//  Defaults
//
//  Created by 村上 幸雄 on 12/01/30.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (strong, nonatomic) NSString  *message;

- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;
@end
