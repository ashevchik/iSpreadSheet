//
//  SnoopWindow.m
//  iPhoneIncubator
//
//  Created by Nick Dalton on 9/25/09.
//  Copyright 360mind 2009. All rights reserved.
//
//

#import "SnoopWindow.h"
#import "Constants.h"


#define SWIPE_DRAG_HORIZ_MIN 40
#define SWIPE_DRAG_VERT_MAX 40
#define ZOOM_DRAG_MIN 20


@implementation SnoopWindow

@synthesize tableView=tableView_;

#pragma mark -
#pragma mark Helper functions for generic math operations on CGPoints

CGFloat CGPointDot(CGPoint a,CGPoint b) {
	return a.x*b.x+a.y*b.y;
}

CGFloat CGPointLen(CGPoint a) {
	return sqrtf(a.x*a.x+a.y*a.y);
}

CGPoint CGPointSub(CGPoint a,CGPoint b) {
	CGPoint c = {a.x-b.x,a.y-b.y};
	return c;
}

CGFloat CGPointDist(CGPoint a,CGPoint b) {
	CGPoint c = CGPointSub(a,b);
	return CGPointLen(c);
}

CGPoint CGPointNorm(CGPoint a) {
	CGFloat m = sqrtf(a.x*a.x+a.y*a.y);
	CGPoint c;
	c.x = a.x/m;
	c.y = a.y/m;
	return c;
}


- (void)sendEvent:(UIEvent *)event {
	NSArray *allTouches = [[event allTouches] allObjects];
	UITouch *touch = [[event allTouches] anyObject];
	UIView *touchView = [touch view];
	
	if (touchView && [touchView isDescendantOfView:self.tableView]) {
		//
		// touchesBegan
		//
		if (touch.phase==UITouchPhaseBegan) {
			startTouchPosition1 = [touch locationInView:self];
			startTouchTime = touch.timestamp;
			
			if ([[event allTouches] count] == 2) {
				startTouchPosition2 = [[allTouches objectAtIndex:1] locationInView:self];
				previousTouchPosition1 = startTouchPosition1;
				previousTouchPosition2 = startTouchPosition2;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDoubleTouchesBegan object:nil userInfo:nil];        
			}
		}
        
		
		//
		// touchesMoved
		//
		if (touch.phase==UITouchPhaseMoved) {
			if ([[event allTouches] count] == 2) {
				CGPoint currentTouchPosition1 = [[allTouches objectAtIndex:0] locationInView:self];
				CGPoint currentTouchPosition2 = [[allTouches objectAtIndex:1] locationInView:self];

        NSNumber * _x1 = [NSNumber numberWithFloat:currentTouchPosition1.x];
        NSNumber * _y1 = [NSNumber numberWithFloat:currentTouchPosition1.y];
        NSNumber * _x2 = [NSNumber numberWithFloat:currentTouchPosition2.x];
        NSNumber * _y2 = [NSNumber numberWithFloat:currentTouchPosition2.y];
        
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_x1, @"x1", _y1, @"y1", _x2, @"x2", _y2, @"y2" , nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDoubleTouchesMoved object:nil userInfo:userInfo];
				}
			}
		}


		//
		// touchesEnded
		///
		if (touch.phase==UITouchPhaseEnded) {
			CGPoint currentTouchPosition = [touch locationInView:self];


      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDoubleTouchesEnded object:nil userInfo:nil];              
			
			// Check if it's a swipe
			NSLog(@"%d %f %d %f time: %g",fabsf(startTouchPosition1.x - currentTouchPosition.x) >= SWIPE_DRAG_HORIZ_MIN ? 1 : 0,
				 fabsf(startTouchPosition1.y - currentTouchPosition.y),
				 fabsf(startTouchPosition1.x - currentTouchPosition.x) > fabsf(startTouchPosition1.y - currentTouchPosition.y)  ? 1 : 0, touch.timestamp - startTouchTime, touch.timestamp - startTouchTime);
			if (fabsf(startTouchPosition1.x - currentTouchPosition.x) >= SWIPE_DRAG_HORIZ_MIN &&
				fabsf(startTouchPosition1.y - currentTouchPosition.y) <= SWIPE_DRAG_VERT_MAX &&
				fabsf(startTouchPosition1.x - currentTouchPosition.x) > fabsf(startTouchPosition1.y - currentTouchPosition.y) &&
				touch.timestamp - startTouchTime < .7
				) {
				// It appears to be a swipe.
				if (startTouchPosition1.x < currentTouchPosition.x) {
					NSLog(@"swipe right");
					[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSwipeRight object:touch];
				} else {
					NSLog(@"swipe left");
					[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSwipeLeft object:touch];
				}
			}
			startTouchPosition1 = CGPointMake(-1, -1);
		}


	[super sendEvent:event];
}

@end
