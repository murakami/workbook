//
//  FlipView.m
//  CoreAnimation
//
//  Created by 村上 幸雄 on 12/03/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "FlipView.h"

@interface FlipView ()
@end

@implementation FlipView

@synthesize imageView = _imageView;
@synthesize isAtMark = _isAtMark;
@synthesize atmarkImage = _atmarkImage;
@synthesize arrowImage = _arrowImage;

- (id)initWithFrame:(CGRect)frame
{
    DBGMSG(@"%s", __func__);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    self.isAtMark = YES;
    self.atmarkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"atmark.png" ofType:nil]];
    self.arrowImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrow.png" ofType:nil]];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(128.0, 176.0, 64.0, 64.0)];
    self.imageView.image = self.atmarkImage;
    [self addSubview:self.imageView];
}

- (void)dealloc
{
    self.atmarkImage = nil;
    self.arrowImage = nil;
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
    [UIView beginAnimations:@"flip view" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.imageView
                             cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    if (self.isAtMark) {
        self.isAtMark = NO;
        self.imageView.image = self.arrowImage;
        
    }
    else {
        self.isAtMark = YES;
        self.imageView.image = self.atmarkImage;        
    }
    [UIView commitAnimations];
}

@end
