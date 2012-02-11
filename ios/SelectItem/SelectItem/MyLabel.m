//
//  MyLabel.m
//  SelectItem
//
//  Created by 村上 幸雄 on 12/02/12.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DBGMSG(@"%s", __func__);
    if (self.highlighted) {
        DBGMSG(@"set self.highlighted to NO.");
        self.highlighted = NO;
    }
    else {
        DBGMSG(@"set self.highlighted to YES.");
        self.highlighted = YES;
    }
}

@end
