//
//  GameBoardView.m
//  FifteenPuzzle
//
//  Created by 村上 幸雄 on 12/07/18.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "GameBoardView.h"
#import "GameSquare.h"
#import "GamePiece.h"

@implementation GameBoardView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    /* [super dealloc]; */
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
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

-(GamePiece*)pieceAtPoint:(CGPoint)pt
{
    return nil;
}

-(GamePiece*)pieceAtIndex:(int)index
{
    return nil;
}

@end
