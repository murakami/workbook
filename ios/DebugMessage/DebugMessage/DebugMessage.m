//
//  DebugMessage.m
//  DebugMessage
//
//  Created by 村上 幸雄 on 12/07/12.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "DebugMessage.h"

@interface DebugMessage ()
@property (strong, nonatomic) NSString  *dbgMsg;
@end

@implementation DebugMessage

@synthesize dbgMsg = _dbgMsg;

- (id)init
{
    return [self initWithString:@""];
}

- (id)initWithString:(NSString *)aString
{
    self = [super init];
    if (self) {
        self.dbgMsg = [[NSString alloc] initWithString:aString];
        if (self.dbgMsg) {
            NSLog(@"[BEGIN]%@", self.dbgMsg);
        }
    }
    return self;
}

- (void)dealloc
{
    if (self.dbgMsg) {
        NSLog(@"[END]%@", self.dbgMsg);
    }
    self.dbgMsg = nil;
    /* [super dealloc]; */
}

@end
