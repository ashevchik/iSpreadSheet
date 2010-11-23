//
//  SpreadSheetScrollView.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/16/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetScrollView.h"


@implementation SpreadSheetScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
  NSLog(@"touchesShouldBegin withEvent inContentView: %p", view);
  return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
  NSLog(@"touchesShouldCancelInContentView: %p", view);
  return YES;
}

- (void)dealloc {
    [super dealloc];
}


@end
