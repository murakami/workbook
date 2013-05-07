//
//  Parser.h
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/05/08.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AssetBrowserParserDelegate <NSObject>
@end

@interface AssetBrowserParser : NSObject

@property (weak, nonatomic) id<AssetBrowserParserDelegate>  delegate;

- (void)parse;
- (void)cancel;

@end
