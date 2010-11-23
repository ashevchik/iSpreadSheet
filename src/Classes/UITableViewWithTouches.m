//
//  UITableViewWithTouches.m
//  SpreadSheet
//
//  Created by Ihar Sapyanik on 20.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UITableViewWithTouches.h"
#import "SpreadSheetAppDelegate.h"
#import "Constants.h"

@implementation UITableViewWithTouches

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesBegan:) name:kNotificationDoubleTouchesBegan object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesMoved:) name:kNotificationDoubleTouchesMoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesEnded:) name:kNotificationDoubleTouchesEnded object:nil];  
    isDoubleTouching_ = NO;
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
      // Initialization code
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesBegan:) name:kNotificationDoubleTouchesBegan object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesMoved:) name:kNotificationDoubleTouchesMoved object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesEnded:) name:kNotificationDoubleTouchesEnded object:nil];  
      isDoubleTouching_ = NO;      
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDoubleTouchesBegan object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDoubleTouchesMoved object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDoubleTouchesEnded object:nil];  
  
  [super dealloc];
}

- (void) touchesBegan: (NSNotification *)note {
  isDoubleTouching_ = YES;
  NSLog(@"touchesBegan");
}


- (void) touchesMoved: (NSNotification *)note {
  
  NSNumber * _x1 = [note.userInfo objectForKey:@"x1"];
  NSNumber * _y1 = [note.userInfo objectForKey:@"y1"];
  NSNumber * _x2 = [note.userInfo objectForKey:@"x2"];
  NSNumber * _y2 = [note.userInfo objectForKey:@"y2"];
  
  SpreadSheetAppDelegate *appDelegate = (SpreadSheetAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  point1_ = [self convertPoint:CGPointMake([_x1 floatValue], [_y1 floatValue])
                      fromView:appDelegate.window];
  
  point2_ = [self convertPoint:CGPointMake([_x2 floatValue], [_y2 floatValue])
                      fromView:appDelegate.window];  

  [self setNeedsDisplay];
}


- (void) touchesEnded: (NSNotification *)note {
  isDoubleTouching_ = NO;
  
}

- (void) drawRect:(CGRect)rect {
  [super drawRect:rect];
  NSLog(@"drawRect");
  if (isDoubleTouching_) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Drawing lines with a white stroke color
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    
    NSLog(@"(%f; %f) - (%f; %f)", point1_.x, point1_.y, point2_.x, point2_.y);    
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, point1_.x, point1_.y);
    CGContextAddLineToPoint(context, point2_.x, point2_.y);
    CGContextStrokePath(context);
  }

}

@end
