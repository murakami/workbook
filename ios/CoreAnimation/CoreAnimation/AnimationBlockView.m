//
//  AnimationBlockView.m
//  CoreAnimation
//
//  Created by 村上 幸雄 on 12/03/08.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "AnimationBlockView.h"

@implementation AnimationBlockView

@synthesize atMarkImageView = _atMarkImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    NSLog(@"%s", __func__);
    UITouch *touch = touches.anyObject;
    [UIView beginAnimations:@"center" context:nil];
    self.atMarkImageView.center = [touch locationInView:self];
    [UIView commitAnimations];
}

@end
