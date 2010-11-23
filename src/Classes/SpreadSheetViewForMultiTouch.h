//
//  SpreadSheetTableView.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/12/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpreadSheetViewForMultiTouch : UIView {
  UIView *viewTouched_;
}
@property (nonatomic, retain) UIView * viewTouched;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
