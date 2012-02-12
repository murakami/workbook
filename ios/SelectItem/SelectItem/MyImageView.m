//
//  MyImageView.m
//  SelectItem
//
//  Created by 村上 幸雄 on 12/02/11.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MyImageView.h"

@interface MyImageView ()
- (void)toggleSwitch;
@end

@implementation MyImageView

@synthesize selected = _selected;

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    self.selected = NO;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    
    self.layer.borderWidth = 3.0f;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
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
        self.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    else {
        DBGMSG(@"set self.selected to YES.");
        self.selected = YES;
        self.layer.borderColor = [[UIColor blueColor] CGColor];
    }
}

@end
