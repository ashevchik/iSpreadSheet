//
//  UITableViewWithTouches.h
//  SpreadSheet
//
//  Created by Ihar Sapyanik on 20.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableViewWithTouches : UITableView {
  CGPoint point1_;
  CGPoint point2_;
  BOOL    isDoubleTouching_;
}


- (void) touchesBegan: (NSNotification *)note;
- (void) touchesMoved: (NSNotification *)note;
- (void) touchesEnded: (NSNotification *)note;
@end
