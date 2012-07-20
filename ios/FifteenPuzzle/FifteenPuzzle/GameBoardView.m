//
//  GameBoardView.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameBoardView.h"
#import "GameSquare.h"
#import "GamePieceView.h"

@implementation GameBoardView

@synthesize delegate = _delegate;
@synthesize squaresArray = _squaresArray;

- (id)initWithFrame:(CGRect)frame
{
    DBGMSG(@"%s", __func__);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    DBGMSG(@"%s", __func__);
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.squaresArray = nil;
    /* [super dealloc]; */
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    DBGMSG(@"%s", __func__);
    // Drawing code
    CGContextRef    context = UIGraphicsGetCurrentContext();
    for (GameSquare *square in self.squaresArray) {
        [square drawContext:context];
    }
}

- (void)setup
{
    CGRect  frame = self.frame;
    CGFloat width = frame.size.width / 4.0;
    CGFloat height = frame.size.height / 4.0;
    CGRect	rect[16] = {
        {0.0,                  0.0,                  width, height},
        {0.0 + width,          0.0,                  width, height},
        {0.0 + (width * 2.0),  0.0,                  width, height},
        {0.0 + (width * 3.0),  0.0,                  width, height},

        {0.0,                  0.0 + height,         width, height},
        {0.0 + width,          0.0 + height,         width, height},
        {0.0 + (width * 2.0),  0.0 + height,         width, height},
        {0.0 + (width * 3.0),  0.0 + height,         width, height},

        {0.0,                  0.0 + (height * 2.0), width, height},
        {0.0 + width,          0.0 + (height * 2.0), width, height},
        {0.0 + (width * 2.0),  0.0 + (height * 2.0), width, height},
        {0.0 + (width * 3.0),  0.0 + (height * 2.0), width, height},
        
        {0.0,                  0.0 + (height * 3.0), width, height},
        {0.0 + width,          0.0 + (height * 3.0), width, height},
        {0.0 + (width * 2.0),  0.0 + (height * 3.0), width, height},
        {0.0 + (width * 3.0),  0.0 + (height * 3.0), width, height}
    };
    self.squaresArray = [[NSMutableArray alloc] init];
    for (int i=0; i < 16; i++) {
        GameSquare* square = [[GameSquare alloc] initWithFrame:rect[i]];
        square.index = i;
        [self.squaresArray addObject:square];
    }
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSSet*		allTouchs = [event allTouches];
	UITouch*	touch = [allTouchs anyObject];
	NSUInteger	taps = [touch tapCount];
	CGPoint		location = [touch locationInView:self];
	
	if( [self.delegate respondsToSelector:@selector(gameBoardViewTouchDown:location:taps:event:)]){
		[self.delegate gameBoardViewTouchDown:self location:location taps:taps event:event];
	}
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSSet*		allTouchs = [event allTouches];
	UITouch*	touch = [allTouchs anyObject];
	NSUInteger	taps = [touch tapCount];
	CGPoint		location = [touch locationInView:self];
	
	if( [self.delegate respondsToSelector:@selector(gameBoardViewTouchMove:location:raps:event:)]){
		[self.delegate gameBoardViewTouchMove:self location:location taps:taps event:event];
	}
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSSet*		allTouchs = [event allTouches];
	UITouch*	touch = [allTouchs anyObject];
	NSUInteger	taps = [touch tapCount];
	CGPoint		location = [touch locationInView:self];
	
	if( [self.delegate respondsToSelector:@selector(gameBoardViewTouchUp:location:taps:event:)]){
		[self.delegate gameBoardViewTouchUp:self location:location taps:taps event:event];
	}
}

-(GameSquare*)squareAtPoint:(CGPoint)pt
{
    return nil;
}

-(GameSquare*)squareAtIndex:(int)index
{
return nil;
}

-(GamePieceView*)pieceViewAtPoint:(CGPoint)pt
{
    return nil;
}

-(GamePieceView*)pieceViewAtIndex:(int)index
{
    return nil;
}

@end
