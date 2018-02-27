//
//  Exam.m
//  Bedrock
//
//  Created by 村上幸雄 on 2018/02/28.
//  Copyright © 2018年 Bitz Co., Ltd. All rights reserved.
//

#import "Exam.h"
@import Toolbox;

@implementation Exam

- (void)dbgmsg
{
    NSLog(@"%s", __func__);
    QuickDraw *qd = [QuickDraw new];
    [qd dbgmsg];
}

@end
