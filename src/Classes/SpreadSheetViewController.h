//
//  SpreadSheetViewController.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableData.h"
#import "SpreadSheetArea.h"
#import "SpreadSheetCellView.h"

typedef enum enActionSheetType {
  actionSheetCell,
  actionSheetCol,
  actionSheetRow,
} enActionSheetType;


@protocol SpreadSheetDelegate

- (void) rowClick: (NSInteger) _rowIndex;
- (void) columnClick: (NSInteger) _columnIndex;
- (void) cellClick: (Point) _cellPoint;

- (void) spreadSheetWillBeginRefreshing;
- (void) spreadSheetDidEndRefreshing;

- (void) spreadSheetWillBeginSelection: (Rect) _selectionArea;
- (void) spreadSheetDidEndSelection: (Rect) _selectionArea;

@end

@class UITableViewWithTouches;

@interface SpreadSheetViewController : UIViewController <UIScrollViewDelegate, 
UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

  @private
 
  UITableViewWithTouches * tableView_;
 
  UIScrollView * leftCol_;
  UIScrollView * topRow_;
  UIView * cell_;
  
  TableData * data_;

  CGFloat leftColWidth_;
  CGFloat leftColHeight_;
  
  CGFloat topRowHeight_;
  CGFloat topRowWidth_;
  
  BOOL draggingTable_;
  BOOL draggingRow_;
  BOOL draggingCol_;
  
  id <SpreadSheetDelegate> delegate_;
  
  enActionSheetType actionSheetType_;
}

@property (nonatomic, retain) IBOutlet UITableViewWithTouches * tableView;

@property (nonatomic, retain) IBOutlet UIScrollView * leftCol;
@property (nonatomic, retain) IBOutlet UIScrollView * topRow;
@property (nonatomic, retain) IBOutlet UIView * cell;

@property (nonatomic, retain) TableData * data;

@property (readwrite) CGFloat leftColWidth;
@property (readwrite) CGFloat leftColHeight;

@property (readwrite) CGFloat topRowWidth;
@property (readwrite) CGFloat topRowHeight;

@property (readwrite) BOOL draggingTable;
@property (readwrite) BOOL draggingRow;
@property (readwrite) BOOL draggingCol;

@property (nonatomic, retain) id <SpreadSheetDelegate> delegate;


// cell actions
- (void) selectCellByCol: (NSInteger) _colNumber andRow: (NSInteger) _rowNumber;
- (void) updateCellByCol: (NSInteger) _colNumber andRow: (NSInteger) _rowNumber;
- (void) deselectAll;

// rows actions
- (void) selectRow: (NSInteger) _rowNumber;
- (void) setRows: (NSArray *) _rows hidden: (BOOL) _hidden;
- (void) setRowAsHeader: (NSInteger) _rowNumber;
- (void) updateRow: (NSInteger) _rowNumber;
- (void) setRow: (NSInteger) _rowNumber height: (CGFloat) _height;

// columns actions
- (void) sortSpreadSheetByColumn: (NSInteger) _columnNumber;
- (void) selectColumn: (NSInteger) _columnNumber;
- (void) setColumns: (NSArray *) _columns hidden: (BOOL) _hidden;
- (void) setColumnAsHeader: (NSInteger) _columnNumber;
- (void) setCol: (NSInteger) _rowNumber width: (CGFloat) _width;

// for testing purposes
- (void) openActionSheetForCol;
- (void) openActionSheetForRow;
- (void) openActionSheetForCell;

@end
