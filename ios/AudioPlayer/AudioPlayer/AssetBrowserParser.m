//
//  Parser.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import "AssetBrowserParser.h"

@implementation AssetBrowserParser

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)parse
{
}

- (void)cancel
{
}

@end
