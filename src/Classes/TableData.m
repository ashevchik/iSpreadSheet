//
//  TableData.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "TableData.h"
#import "NSMutableArray+Sort.h"
#import "SpreadSheetProperties.h"

@interface TableData (Private)

- (NSMutableArray *) getVisibleCellsFromArray: (NSArray *) _array;
- (NSMutableArray *) getVisibleCellsFromRow: (NSArray *) _row;
- (NSMutableArray *) getVisibleCellsFromCol: (NSArray *) _col;

- (void) setDataToTopRow: (NSMutableArray *) _data;

- (void) updateRowsFromData;
- (void) _printData;

@end

@implementation TableData (Private)

- (void) _printData {
  
  printf("data:\n");
  
  for (NSArray * _row in self.data) {
    for (CellData * _cell in _row) {
      printf(" %02d(%d-%d)", [(NSNumber *)_cell.value intValue], [_cell isHiddenAsCol], [_cell isHiddenAsRow]);
    }
    printf("\n");
  }
}

- (void) clearAlreadySortedFlag {
  
  if ([self.data count]) {
    for (CellData * _cell in [self.data objectAtIndex:0]) {
      [_cell setAlreadySorted:NO];
    }
  }
}

- (NSMutableArray *) getVisibleCellsFromRow: (NSArray *) _row {
  
  NSMutableArray * _arrayToReturn = [NSMutableArray array];
  
  for (CellData * _cell in _row) {
    if ([_cell isHiddenAsCol] == NO) {
      [_arrayToReturn addObject:_cell];
    } 
  }
  return _arrayToReturn;
}

- (NSMutableArray *) getVisibleCellsFromCol: (NSArray *) _col {
  
  NSMutableArray * _arrayToReturn = [NSMutableArray array];
  
  for (CellData * _cell in _col) {
    if ([_cell isHiddenAsRow] == NO) {
      if (_cell.point.v != self.indexLeftCol) {
        [_cell setCellType: cellTypeSimple];
      }
      [_arrayToReturn addObject:_cell];
    } 
  }
  return _arrayToReturn;
}

- (NSMutableArray *) getVisibleCellsFromArray: (NSArray *) _array {
  
  NSMutableArray * _arrayToReturn = [NSMutableArray array];
  
  for (CellData * _cell in _array) {
    if ([_cell isVisible]) {
      [_arrayToReturn addObject:_cell];
    } 
  }
  return _arrayToReturn;
}

- (void) setDataToTopRow: (NSMutableArray *) _row {
  
  NSRange rangeTopRow;
  if (self.indexLeftCol == 0) {
    rangeTopRow = NSMakeRange(1, [_row count]-1);
  } else {
    rangeTopRow = NSMakeRange(0, [_row count]);
  }
  NSMutableArray * _topRow = [self getVisibleCellsFromRow:[_row subarrayWithRange:rangeTopRow]];
  for (CellData * _cell in _topRow) {
    [_cell setCellType:cellTypeTopRow];
    [_cell setSelected:NO];
  }
  if ([_topRow count]) {
    [self setTopRow: _topRow];
  }
  [self setVisibleCols: [_topRow count]];
}
  
- (void) updateCellFromData {
  
  if (self.indexTopRow>=0 && self.indexTopRow<[self.data count]) {
    NSMutableArray * _row = [self.data objectAtIndex:self.indexTopRow];
    if (self.indexLeftCol>=0 && self.indexLeftCol<[_row count]) {
      CellData * _cell = [_row objectAtIndex:self.indexLeftCol];
      [_cell setCellType:cellTypeTopLeft];
      [_cell setSelected: NO];
      [self setCell: _cell];
    }
  }
}

- (void) updateRowsFromData {

  NSMutableArray * _leftCol = [NSMutableArray arrayWithCapacity:([self.data count]-1)];
  NSMutableArray * _rows = [NSMutableArray arrayWithCapacity:([self.data count]-1)];
  
  for (NSMutableArray * _row in self.data) {
    
    if ([self.data indexOfObject: _row] == self.indexTopRow) {

      [self setDataToTopRow:_row];

    } else {
      
      if ([_row count] > self.indexLeftCol) {
        
        CellData * _cellLefCol = [_row objectAtIndex: self.indexLeftCol];
        if ([_cellLefCol isHiddenAsRow] == NO) {
          [_cellLefCol setCellType:cellTypeLeftCol];
          [_cellLefCol setSelected: NO];
          [_leftCol addObject:_cellLefCol]; 
        }

        NSRange rangeRow;
        
        if (self.indexLeftCol == 0) {
          rangeRow = NSMakeRange(1, [_row count]-1);
        } else {
          rangeRow = NSMakeRange(0, [_row count]);
        }

        NSMutableArray * _rowToAdd = [self getVisibleCellsFromCol: [_row subarrayWithRange:rangeRow]];
        if ([_rowToAdd count]) {
          [_rows addObject:_rowToAdd];
        }
      } 
    }
  }
  
  [self setLeftCol: _leftCol];
  [self setRows: _rows];
  [self setVisibleRows: [_leftCol count]];
}

@end


@implementation TableData

@synthesize cell=cell_;
@synthesize leftCol=leftCol_;
@synthesize topRow=topRow_;
@synthesize rows=rows_;

@synthesize data=data_;

@synthesize indexTopRow=indexTopRow_;
@synthesize indexLeftCol=indexLeftCol_;

@synthesize visibleRows=visibleRows_;
@synthesize visibleCols=visibleCols_;

- (id)initWithFakeData {
  
#define KFakeColsNumber 30
#define kFakeRowsNumber 200
  
  if (self = [super init]) {

    NSMutableArray * _data = [NSMutableArray arrayWithCapacity:kFakeRowsNumber];
    
    for (int irow = 0; irow<kFakeRowsNumber; irow++) {

      NSMutableArray * _cells = [NSMutableArray arrayWithCapacity:kFakeRowsNumber];
      
      for (int icell = 0; icell<KFakeColsNumber; icell++) {
        
        Point cellIndex = {icell, irow};
        CellData * _cellData = nil;
        
        if (icell == 0 || irow == 0) {
          NSString * strCell = [NSString stringWithFormat:@"Cell %d %d", irow+1, icell+1];
          _cellData = [[[CellData alloc] initWithIndex: cellIndex value: strCell width: 150 height: 55] autorelease];
        } else {
          NSNumber * _number = [NSNumber numberWithFloat:rand()%100];
          _cellData = [[[CellData alloc] initWithIndex: cellIndex value: _number width: 150 height: 55] autorelease];
        }
        if (icell == 2 && irow != 0) {
          [_cellData setImageIndex:1];
          [_cellData setImageViewAligment: UIViewContentModeLeft];
        } 
        
        if (icell == 3 && irow != 0) {
          [_cellData setImageIndex:2];
          [_cellData setImageViewAligment: UIViewContentModeRight];
        }
        [_cells addObject:_cellData];
      }
      
      [_data addObject: _cells];
    }
    
    [self setData: _data];
    
    [self setIndexTopRow: 0];
    [self setIndexLeftCol: 0];

    [self updateCellFromData];
    [self updateRowsFromData];
    
  }    
  return self;
}

#pragma mark -
#pragma mark ColsActions

- (void) setCol:(NSInteger) _columnNumber hidden: (BOOL) _hidden {
  
  for (NSArray * _row in self.data) {
    for (CellData * _cell in _row) {
      if ([_row indexOfObject:_cell] == _columnNumber) {
        [_cell setCellType:cellTypeSimple];
        [_cell setColHidden: _hidden];
      }
    }
  }
  [self updateRowsFromData];
}

- (void) setColAsLeft: (NSInteger) _columnNumber {
  
  [self setIndexLeftCol: _columnNumber];
  [self updateCellFromData];
  [self updateRowsFromData];
}

- (void) selectCol: (NSInteger) _colIndex {
  
  BOOL _selectFlag = NO;
  if ([self.data count]) {
    NSArray * _topRow = [self.data objectAtIndex:0];
    if ([_topRow count]>_colIndex) {
      CellData * _cell = [_topRow objectAtIndex:_colIndex];
      _selectFlag = !_cell.isSelected;
    }
  }
  for (NSArray * _row in self.data) {
    for (CellData * _cell in _row) {
      if ([_row indexOfObject:_cell] == _colIndex) {
        [_cell setSelected: _selectFlag];
      }
    }
  }
}

- (RowColData *) getColForIndex: (NSInteger) _colIndex {

  NSMutableArray * _dataForCol = [NSMutableArray array];

  for (NSArray * _row in self.data) {
    if ([_row count]>_colIndex) {
      CellData * _cell = [_row objectAtIndex: _colIndex];
      [_dataForCol addObject: _cell];
    }
  }
  return [[RowColData alloc] initWithRowColData: [NSArray arrayWithArray: _dataForCol]];
}

- (void) setCol: (NSInteger) _rowNumber width: (CGFloat) _width {
  
  RowColData * _col = [self getColForIndex:_rowNumber];
  [_col setWidth:_width];
}

#pragma mark -
#pragma mark RowsActions

- (void) setRow:(NSInteger) _rowNumber hidden: (BOOL) _hidden {
  
  for (NSArray * _row in self.data) {
    if ([self.data indexOfObject:_row] == _rowNumber) {
      for (CellData * _cell in _row) {
        [_cell setCellType:cellTypeSimple];
        [_cell setRowHidden: _hidden];
      }
    }
  }
  [self updateRowsFromData];
}

- (void) setRowAsTop: (NSInteger) _rowNumber {
  
  [self setIndexTopRow: _rowNumber];
  [self updateCellFromData];
  [self updateRowsFromData];
}

- (void) selectRow: (NSInteger) _rowIndex {
  
  if (_rowIndex>0 && _rowIndex < [self.data count]) {
    BOOL _selectFlag = NO;
    NSArray * _row = [self.data objectAtIndex: _rowIndex];
    if ([_row count]) {
      CellData * _cell = [_row objectAtIndex:0];
      _selectFlag = !_cell.isSelected;
    }
    for (CellData * _cell in [self.data objectAtIndex:_rowIndex]) {
      [_cell setSelected: _selectFlag];
    }
  }
}

- (void) sortRowsByColumn: (NSInteger) _columnNumber {
  
  NSArray * _dataTopRow = [self.data objectAtIndex:0];
  if ([_dataTopRow count]>_columnNumber) {
    CellData * _cell = [_dataTopRow objectAtIndex: _columnNumber];
    if ([_cell isAlreadySorted]) {
      NSLog(@"already sorted");
      return;
    }
  }
  [self clearAlreadySortedFlag];
  
  [[SpreadSheetProperties sharedSpreadSheetProperties] setSelectedCol: _columnNumber];
  NSRange _range = NSMakeRange(1, [self.data count]-1);
  NSArray * _dataWithOutTopRow = [self.data subarrayWithRange:_range];
  NSArray * _sortedArray = [_dataWithOutTopRow sortedArrayUsingSelector:@selector(compareWithArray:)];
  NSMutableArray * _sortedData = [NSMutableArray arrayWithObject: _dataTopRow];
  [_sortedData addObjectsFromArray: _sortedArray];
  
  for (NSUInteger irow=0; irow<[_sortedData count]; irow++) {
    for (CellData * _cell in [_sortedData objectAtIndex:irow]) {
      Point _point = _cell.point;
      _point.h = irow;
      [_cell setPoint:_point];
    }
  }
  
  [self setData:_sortedData];
  [self updateRowsFromData];
  if ([_dataTopRow count]>_columnNumber) {
    CellData * _cell = [_dataTopRow objectAtIndex: _columnNumber];
    [_cell setAlreadySorted:YES];
  }
    
}

- (RowColData *) getRowForIndex: (NSInteger) _rowIndex {

  if ([self.data count]>_rowIndex) {
    NSArray * _dataForRow = [self.data objectAtIndex: _rowIndex];
    return [[RowColData alloc] initWithRowColData: _dataForRow];
  }
  return [[RowColData alloc] initWithRowColData:[NSArray array]];
}

- (void) setRow: (NSInteger)_rowNumber height: (CGFloat)_height {
  
  RowColData * _row = [self getRowForIndex:_rowNumber];
  [_row setHeight:_height];
}

#pragma mark -
#pragma mark CellsActions

- (void) selectCell: (Point) _point {
  
  CellData * _cell = [self getCellFromPoint:_point];
  if (_cell) {
    [_cell setSelected: !_cell.isSelected];
  }
}

- (void) selectRect: (Rect) _rect {
/*
  for (NSArray * _row in self.data) {
    for (CellData * _cell in _row) {
      if (_cell.x>=_rect.left && _cell.x<=_rect.right && _cell.y>=_rect.top && _cell.y<=_rect.bottom) {
        [_cell setSelected:YES];
      }
    }
  }
*/
}

- (CellData *) getCellFromPoint: (Point) _point {
  
  if (_point.h>=0 && _point.h<[self.data count]) {
    NSArray * _row = [self.data objectAtIndex:_point.h];
    if (_point.v>=0 && _point.v<[_row count]) {
      return [_row objectAtIndex:_point.v];
    }
  }
  return nil;
}

- (void) deselectAll {

  for (NSArray * _row in self.data) {
    for (CellData * _cell in _row) {
      [_cell setSelected: NO];
    }
  }
}

- (void)dealloc {
  
  [topRow_ release];
  [leftCol_ release];
  [rows_ release];
  [cell_ release];
  
  [super dealloc];
}



@end
