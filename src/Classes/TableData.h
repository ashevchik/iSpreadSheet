//
//  TableData.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellData.h"
#import "RowColData.h"

@interface TableData : NSObject {

  @private 
  
  CellData * cell_;
  NSMutableArray * topRow_;
  NSMutableArray * leftCol_;
  
  NSMutableArray * rows_;
  
  NSMutableArray * data_;
  
  NSInteger indexTopRow_;
  NSInteger indexLeftCol_;
  
  NSInteger visibleRows_;
  NSInteger visibleCols_;
}

@property (nonatomic, retain) CellData * cell;
@property (nonatomic, retain) NSMutableArray * leftCol;
@property (nonatomic, retain) NSMutableArray * topRow;
@property (nonatomic, retain) NSMutableArray * rows;

@property (nonatomic, retain) NSMutableArray * data;

@property (readwrite) NSInteger indexTopRow;
@property (readwrite) NSInteger indexLeftCol;

@property (readwrite) NSInteger visibleRows;
@property (readwrite) NSInteger visibleCols;

// init
- (id)initWithFakeData;

// columns
- (void) setCol:(NSInteger) _columnNumber hidden: (BOOL) _hidden;
- (void) setColAsLeft: (NSInteger) _columnNumber;
- (void) selectCol: (NSInteger) _colIndex;
- (RowColData *) getColForIndex: (NSInteger) _colIndex;
- (void) setCol: (NSInteger) _rowNumber width: (CGFloat) _width;

// rows
- (void) setRow:(NSInteger) _rowNumber hidden: (BOOL) _hidden;
- (void) setRowAsTop: (NSInteger) _rowNumber;
- (void) selectRow: (NSInteger) _rowIndex;
- (void) sortRowsByColumn: (NSInteger) _columnNumber;
- (RowColData *) getRowForIndex: (NSInteger) _rowIndex;
- (void) setRow: (NSInteger)_rowNumber height: (CGFloat)_height;

// cells
- (void) selectCell: (Point) _point;
- (void) selectRect: (Rect) _rect;
- (CellData *) getCellFromPoint: (Point) _point;
- (void) deselectAll;


@end
