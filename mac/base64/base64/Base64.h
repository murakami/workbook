//
//  Base64.h
//  base64
//
//  Created by 村上 幸雄 on 12/05/23.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+ (NSString *)encodeBase64:(NSData *)data;
@end
