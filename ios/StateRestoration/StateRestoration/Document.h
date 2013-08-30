//
//  Document.h
//  StateRestoration
//
//  Created by 村上 幸雄 on 13/08/18.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject
@property (strong, nonatomic) NSString          *version;
@property (strong, nonatomic) NSMutableArray    *objects;

+ (Document *)sharedDocument;
- (void)load;
- (void)save;
@end
