//
//  Database.h
//  Database
//
//  Created by 村上 幸雄 on 12/07/03.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject

@property (nonatomic, assign) sqlite3   *database;

- (void)demo;

@end
