//
//  Document.h
//  Books
//
//  Created by 村上 幸雄 on 12/04/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (strong, nonatomic) NSString  *version;

- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;
@end
