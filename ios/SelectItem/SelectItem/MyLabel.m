//
//  MyLabel.m
//  SelectItem
//
//  Created by 村上 幸雄 on 12/02/12.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyLabel.h"

@interface MyLabel ()
- (void)toggleSwitch;
@end

@implementation MyLabel

@synthesize selected = _selected;

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    self.selected = NO;
    self.textColor = [UIColor grayColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DBGMSG(@"%s", __func__);
    [self toggleSwitch];
}

- (void)toggleSwitch
{
    DBGMSG(@"%s", __func__);
    if (self.selected) {
        DBGMSG(@"set self.selected to NO.");
        self.selected = NO;
        self.textColor = [UIColor grayColor];
    }
    else {
        DBGMSG(@"set self.selected to YES.");
        self.selected = YES;
        self.textColor = [UIColor blueColor];
    }
}

@end
