//
//  Event_description.m
//  Datum
//
//  Created by 村上 幸雄 on 12/07/12.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "Event_description.h"

@implementation Event(description)

- (NSString *)description
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString    *str = [formatter stringFromDate:self.timeStamp];
    return str;
}

@end
