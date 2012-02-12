//
//  MyImageView.m
//  SelectItem
//
//  Created by 村上 幸雄 on 12/02/11.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyImageView.h"

@interface MyImageView ()
- (void)toggleSwitch;
@end

@implementation MyImageView

@synthesize imageView = _imageView;
@synthesize selected = _selected;

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    self.selected = NO;
    self.backgroundColor = [UIColor grayColor];
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
        self.backgroundColor = [UIColor grayColor];
    }
    else {
        DBGMSG(@"set self.selected to YES.");
        self.selected = YES;
        self.backgroundColor = [UIColor blueColor];
    }
}

@end
