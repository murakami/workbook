//
//  AnimatingTransitionView.m
//  CoreAnimation
//
//  Created by 村上 幸雄 on 12/03/11.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AnimatingTransitionView.h"

@interface AnimatingTransitionView ()
@end

@implementation AnimatingTransitionView

@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.label.text = [formatter stringFromDate:date];
}

- (void)dealloc
{
    self.label = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CATransition    *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.label.text = [formatter stringFromDate:date];
    [[self.label layer] addAnimation:animation forKey:@"animation transition"];
}

@end
