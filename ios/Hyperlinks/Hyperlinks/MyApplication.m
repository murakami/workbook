//
//  MyApplication.m
//  Hyperlinks
//
//  Created by 村上 幸雄 on 12/05/03.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyApplication.h"

@implementation MyApplication

- (BOOL)openURL:(NSURL *)url
{
    NSLog(@"%s, url(%@)", __func__, url);
    return [super openURL:url];
}

@end
