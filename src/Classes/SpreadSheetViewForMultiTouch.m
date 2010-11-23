//
//  SpreadSheetTableView.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/12/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetViewForMultiTouch.h"


@implementation SpreadSheetViewForMultiTouch

@synthesize viewTouched=viewTouched_;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self setMultipleTouchEnabled: YES];
  }
  return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder: aDecoder]) {
    [self setMultipleTouchEnabled: YES];
  }
  return self;
}


/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  NSLog(@"touchesBegan");
  
  UITouch *aTouch = [touches anyObject];
  if (aTouch.tapCount == 2) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  NSLog(@"touchesMoved");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  NSLog(@"touchesEnded");
  
  UITouch *theTouch = [touches anyObject];
  if (theTouch.tapCount == 1) {
    NSDictionary *touchLoc = [NSDictionary dictionaryWithObject:
                              [NSValue valueWithCGPoint:[theTouch locationInView:self]] forKey:@"location"];
    [self performSelector:@selector(handleSingleTap:) withObject:touchLoc afterDelay:0.3];
  } else if (theTouch.tapCount == 2) {
    // Double-tap: increase image size by 10%"
    CGRect myFrame = self.frame;
    myFrame.size.width += self.frame.size.width * 0.1;
    myFrame.size.height += self.frame.size.height * 0.1;
    myFrame.origin.x -= (self.frame.origin.x * 0.1) / 2.0;
    myFrame.origin.y -= (self.frame.origin.y * 0.1) / 2.0;
    [UIView beginAnimations:nil context:NULL];
    [self setFrame:myFrame];
    [UIView commitAnimations];
  }
}

- (void)handleSingleTap:(NSDictionary *)touches {
  
  NSLog(@"handleSingleTap");
  // Single-tap: decrease image size by 10%"
  CGRect myFrame = self.frame;
  myFrame.size.width -= self.frame.size.width * 0.1;
  myFrame.size.height -= self.frame.size.height * 0.1;
  myFrame.origin.x += (self.frame.origin.x * 0.1) / 2.0;
  myFrame.origin.y += (self.frame.origin.y * 0.1) / 2.0;
  [UIView beginAnimations:nil context:NULL];
  [self setFrame:myFrame];
  [UIView commitAnimations];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesCancelled");
}
*/ 
 
//The basic idea here is to intercept the view which is sent back as the firstresponder in hitTest.
//We keep it preciously in the property viewTouched and we return our view as the firstresponder.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  NSLog(@"Hit Test");
  self.viewTouched = [super hitTest:point withEvent:event];
  return self;
}

//Then, when an event is fired, we log this one and then send it back to the viewTouched we kept, and voilà!!! :)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch Began");
  [self.viewTouched touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch Moved");
  [self.viewTouched touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch Ended");
  [self.viewTouched touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch Cancelled");
}

- (void)dealloc {
    [super dealloc];
}


@end
