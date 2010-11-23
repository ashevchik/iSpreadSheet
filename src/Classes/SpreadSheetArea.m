//
//  SpreadSheetArea.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetArea.h"
#import "SpreadSheetCellView.h"
#import "CellData.h"

@interface SpreadSheetArea (Private)

- (CGFloat) calcRowWidth: (NSArray *) _row;
- (CGFloat) calcRowHeight: (NSArray *) _row;
- (void) createRowViews: (NSArray *) _row;
- (void) updateRowViewsWithData: (NSArray *) _data;

- (CGFloat) calcColWidth: (NSArray *) _col;
- (CGFloat) calcColHeight: (NSArray *) _col;
- (void) createColViews: (NSArray *) _col;
- (void) updateColViewsWithData: (NSArray *) _data;

- (CGFloat) calcRectWidth: (NSArray *) _rect;
- (CGFloat) calcRectHeight: (NSArray *) _rect;
- (void) createRectViews: (NSArray *) _rect;

@end

@implementation SpreadSheetArea (Private)

- (CGFloat) calcRowWidth: (NSArray *) _row {
 
  CGFloat frameWidth = 0;
  for (CellData * _cellData in _row) {
    if ([_cellData isHiddenAsCol] == NO) {
      frameWidth += _cellData.width; 
    }
  }  
  return frameWidth;
}

- (CGFloat) calcRowHeight: (NSArray *) _row {
  
  if ([_row count]) {
    return [(CellData *)[_row objectAtIndex:0] height];
  }
  return 0;
}

- (void) createRowViews: (NSArray *) _row {
  
  CGFloat startX = 0;
  CGFloat startY = 0;
  for (CellData * _cellData in _row) {
    
    if ([_cellData isHiddenAsCol] == NO) {
      CGRect frame = CGRectMake(startX, startY, _cellData.width, _cellData.height);
      SpreadSheetCellView * view = [[SpreadSheetCellView alloc] initWithFrame:frame andData: _cellData];
      [self addSubview:view];
      startX += _cellData.width;
    }
  }
}

- (void) updateRowViewsWithData: (NSArray *) _data {
  
  CGFloat startX = 0;
  CGFloat startY = 0;
  for (NSInteger icell=0; icell<[_data count]; icell++) {
    CellData * _cellData = [_data objectAtIndex:icell];
    SpreadSheetCellView * _cellView = [self.subviews objectAtIndex: icell];
    CGRect dataFrame = CGRectMake(startX, startY, _cellData.width, _cellData.height);
    
    // if needed updating frame
    if (!CGRectEqualToRect(dataFrame, _cellView.frame)) {
      [_cellView setFrame:dataFrame];
    }

    [_cellView setCellData:_cellData];
    // updating cell
    [_cellView updateCell];
    startX += _cellData.width;
  }
  
  if ([_data count]) {
    CGRect _frame = CGRectMake(0, 0, startX, [[_data objectAtIndex:0] height]);
    // if needed updating frame
    if (!CGRectEqualToRect(self.frame, _frame)) {
      [self setFrame:_frame];
    }
  }
}

- (CGFloat) calcColWidth: (NSArray *) _col {

  if ([_col count]) {
    return [(CellData *)[_col objectAtIndex:0] width];
  }
  return 0;
}

- (CGFloat) calcColHeight: (NSArray *) _col {

  CGFloat frameHeight = 0;
  for (CellData * _cellData in _col) {
    if ([_cellData isHiddenAsRow] == NO) {
      frameHeight += _cellData.height; 
    }
  }  
  return frameHeight;
}

- (void) createColViews: (NSArray *) _col {
  
  CGFloat startX = 0;
  CGFloat startY = 0;
  for (CellData * _cellData in _col) {
    if ([_cellData isHiddenAsRow]==NO) {
      CGRect frame = CGRectMake(startX, startY, _cellData.width, _cellData.height);
      SpreadSheetCellView * view = [[SpreadSheetCellView alloc] initWithFrame:frame andData: _cellData];
      [self addSubview:view];
      startY += _cellData.height;
    }
  }
}

- (void) updateColViewsWithData: (NSArray *) _data {
  
  CGFloat startX = 0;
  CGFloat startY = 0;

  for (int icell=0; icell<[_data count]; icell++) {
    
    CellData * _cellData = [_data objectAtIndex:icell];
    SpreadSheetCellView * _cellView = [self.subviews objectAtIndex:icell];
    
    CGRect dataFrame = CGRectMake(startX, startY, _cellData.width, _cellData.height);
    // if needed updating frame
    if (!CGRectEqualToRect(dataFrame, _cellView.frame)) {
      [_cellView setFrame:dataFrame];
    }
    [_cellView setCellData:_cellData];
    // updating cell
    [_cellView updateCell];
    
    startY += _cellData.height;
  }
  
  if ([_data count]) {
    CGRect _frame = CGRectMake(0, 0, [[_data objectAtIndex:0] width], startY);
    [self setFrame:_frame];
  }
}

- (CGFloat) calcRectWidth: (NSArray *) _rect {
  
  CGFloat frameWidth = 0;
  if ([_rect count]) {
    for (CellData * _cellData in (NSArray *)[_rect objectAtIndex:0]) {
      if (_cellData.isVisible) {
        frameWidth += _cellData.width; 
      }
    }  
  }
  return frameWidth;
}

- (CGFloat) calcRectHeight: (NSArray *) _rect {

  CGFloat frameHeight = 0;
  for (NSArray * _row in _rect) {
    if ([_row count]) {
      if ([(CellData *)[_row objectAtIndex:0] isVisible]) {
        frameHeight += [(CellData *)[_row objectAtIndex:0] height]; 
      }
    }
  }  
  return frameHeight;
}

- (void) createRectViews: (NSArray *) _rect {
  
  CGFloat startY = 0;
  for (NSArray * _row in _rect) {
    CGFloat startX = 0;
    for (CellData * _cellData in _row) {
      if (_cellData.isVisible) {
        CGRect frame = CGRectMake(startX, startY, _cellData.width, _cellData.height);
        SpreadSheetCellView * view = [[SpreadSheetCellView alloc] initWithFrame:frame andData: _cellData];
        [self addSubview:view];
        startX += _cellData.width;
      }
    }
    if ([_row count]) {
      startY += [(CellData *)[_row objectAtIndex:0] height];
    }
  }
}

@end

@implementation SpreadSheetArea

- (id) initRowWithData: (NSArray *) _data {

  if (self = [super initWithFrame:CGRectMake(0, 0, [self calcRowWidth: _data], [self calcRowHeight: _data])]) {
    [self createRowViews: _data];
  }
  return self;
}

- (id) initColWithData: (NSArray *) _data {
  
  if (self = [super initWithFrame:CGRectMake(0, 0, [self calcColWidth: _data], [self calcColHeight: _data])]) {
    [self createColViews: _data];
  }
  return self;
}

- (id) initRectWithData: (NSArray *) _data {
  
  if (self = [super initWithFrame:CGRectMake(0, 0, [self calcRectWidth: _data], [self calcRectHeight: _data])]) {
    [self createRectViews: _data];
  }
  return self;
}

- (void) updateRowWithData: (NSArray *) _data {
  
  if ([_data count] == [self.subviews count]) {
    [self updateRowViewsWithData: _data];
  } else {
    for(UIView * subview in self.subviews) {
      [subview removeFromSuperview];
    }
    CGRect _frame = CGRectMake(0, 0, [self calcRowWidth: _data], [self calcRowHeight: _data]);
    if (!CGRectEqualToRect(self.frame, _frame)) {
      [self setFrame: _frame];
    }
    [self createRowViews: _data];
  }
}

- (void) updateColWithData: (NSArray *) _data {
  
  if ([_data count] == [self.subviews count]) {
    [self updateColViewsWithData: _data];
  } else {
    for(UIView * subview in self.subviews) {
      [subview removeFromSuperview];
    }
    [self setFrame:CGRectMake(0, 0, [self calcColWidth: _data], [self calcColHeight: _data])];
    [self createColViews: _data];
  }
}

- (void)dealloc {
    [super dealloc];
}


@end
