//
//  GameSquare.h
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/20.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSquare : NSObject
@property (nonatomic, assign) CGRect    frame;
@property (nonatomic, assign) int       index;
@property (nonatomic, assign) BOOL      isEmpty;

- (id)initWithFrame:(CGRect)frame;
- (void)drawContext:(CGContextRef)context;
- (BOOL)squareCheck:(CGPoint)point;
@end
