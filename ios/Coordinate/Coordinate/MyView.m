//
//  MyView.m
//  Coordinate
//
//  Created by 村上 幸雄 on 12/02/15.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MyView.h"

@interface MyView ()
@end

@implementation MyView

@synthesize upperLeftOriginImage = _upperLeftOriginImage;

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
    self.upperLeftOriginImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"upper-left-origin.png" ofType:nil]];
}

-(void)dealloc
{
    self.upperLeftOriginImage = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /* ULO(upper-left-origin) */
    [self.upperLeftOriginImage drawAtPoint:CGPointMake(10.0, 10.0)];
}

@end
