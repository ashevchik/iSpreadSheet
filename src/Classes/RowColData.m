//
//   RowData.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/18/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "RowColData.h"


@implementation RowColData

@synthesize data=data_;

- (id) initWithRowColData: (NSArray *) _data {
  if (self = [super init]) {
    [self setData:_data];
  }
  return self;
}

- (void) dealloc {
  [data_ release];
  [super dealloc];
}

- (void) setColor: (UIColor *) _color {
  for (CellData * _cell in self.data) {
    [_cell setColor:_color];
  }
}

- (void) setFont: (UIFont *) _font {
  for (CellData * _cell in self.data) {
    [_cell setFont: _font];
  }
}

- (void) setBackGroundColor: (UIColor *) _backgroundColor {
  for (CellData * _cell in self.data) {
    [_cell setBgColor: _backgroundColor];
  }
}

- (void) setBorderThickness: (CGFloat) _thickness {
  for (CellData * _cell in self.data) {
    [_cell setThickness: _thickness];
  }
}

- (void) setTextAligment: (UITextAlignment) _labesAlignment {
  for (CellData * _cell in self.data) {
    [_cell setLabelAlignment: _labesAlignment];
  }
}

- (void) setWidth: (CGFloat) _width {
  for (CellData * _cell in self.data) {
    [_cell setWidth:_width];
  }
}

- (void) setHeight: (CGFloat) _height {
  for (CellData * _cell in self.data) {
    [_cell setHeight:_height];
  }
}

@end
