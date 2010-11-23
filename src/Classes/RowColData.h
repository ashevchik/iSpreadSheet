//
//   RowData.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/18/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellData.h"

@interface RowColData : NSObject {
  
  NSArray * data_;
}

@property (nonatomic, retain) NSArray * data;

- (id) initWithRowColData: (NSArray *) _data;

- (void) setColor: (UIColor *) _color;
- (void) setFont: (UIFont *) _font;
- (void) setBackGroundColor: (UIColor *) _backgroundColor;
- (void) setBorderThickness: (CGFloat) _thickness;
- (void) setTextAligment: (UITextAlignment) _labesAlignment;

- (void) setWidth: (CGFloat) _width;
- (void) setHeight: (CGFloat) _height;

@end
