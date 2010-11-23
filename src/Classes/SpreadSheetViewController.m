//
//  SpreadSheetViewController.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetViewController.h"
#import "SpreadSheetAppDelegate.h"
#import "SnoopWindow.h"
#import "SpreadSheetCell.h"
#import "SpreadSheetCellView.h"
#import "SpreadSheetArea.h"
#import "CellData.h"
#import "Constants.h"
#import "SpreadSheetProperties.h"
#import "RowColData.h"
#import "UITableViewWithTouches.h"

@interface SpreadSheetViewController (Private) 

- (void) settingLeftColWidth;
- (void) settingTopRowHeight;

- (void) setTableSettings;
- (void) setTableDimenstions;

- (void) setTopRowViewAndData;
- (void) setTopRowDimensions;

- (void) setLeftColViewAndData;
- (void) setLeftColDimensions;

- (void) setCellData;
- (void) setCellDimensions;

- (void) updateTableViewsDimensions;
- (void) updateDimensions;
- (void) updateTableAndViews;

- (void) registerNotifications;
- (void) cellTapped: (NSNotification *)note;
- (void) touchesBegan: (NSNotification *)note;
- (void) touchesMoved: (NSNotification *)note;
- (void) touchesEnded: (NSNotification *)note;

- (void) _printfFrameDimensions: (CGRect) _frame;

@end

@implementation SpreadSheetViewController (Private)

- (void) _printfFrameDimensions: (CGRect) _frame {
  NSLog(@"frame (%f; %f; %f; %f)", _frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);
}

- (void) settingLeftColWidth {
  
  if ([self.data.leftCol count]) {
    self.leftColWidth = [(CellData *)[self.data.leftCol objectAtIndex:0] width];
    self.leftColHeight = [(CellData *)[self.data.leftCol objectAtIndex:0] height];
  } else {
    self.leftColWidth = 0.0;
    self.leftColHeight = 0.0;
  }
}

- (void) settingTopRowHeight {
  
  if ([self.data.topRow count]) {
    self.topRowWidth = [(CellData *)[self.data.topRow objectAtIndex:0] width];
    self.topRowHeight = [(CellData *)[self.data.topRow objectAtIndex:0] height];
  } else {
    self.topRowWidth = 0.0;
    self.topRowHeight = 0.0;
  }
}

- (void) setTableSettings {

  [tableView_ setDirectionalLockEnabled: YES];
  [tableView_ setBounces:NO];
  [tableView_ setAllowsSelection:NO];
  
  [self setTableDimenstions];
}

- (void) setTableDimenstions {

  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  
  CGRect _frameTopRow = [[self.topRow.subviews objectAtIndex:0] frame];
  
  CGFloat _tableWidth  = _frameTopRow.size.width;
  CGFloat _tableHeight = frameSpreadSheet.size.height-self.topRowHeight;
  
  // tricky thing here - we need to set the full (more than screen width) width for table frame
  [self.tableView setFrame:CGRectMake(self.leftColWidth, self.topRowHeight, _tableWidth, _tableHeight)];
  [self.tableView setContentSize:CGSizeMake(_tableWidth, self.leftColHeight)];
  
  // + 1 the table border thickness
  CGFloat insetLeft = _tableWidth - (frameSpreadSheet.size.width-self.leftColWidth) + 1;
  UIEdgeInsets edgeInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, insetLeft);
  [self.tableView setContentInset: edgeInset];
}

- (void) setTopRowViewAndData {

  [self.topRow setDirectionalLockEnabled:YES];
  [self.topRow setBounces:NO];  

  SpreadSheetArea * _viewTopRow = [[[SpreadSheetArea alloc] initRowWithData:self.data.topRow] autorelease];
  [self.topRow addSubview:_viewTopRow];
  
  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  
  [self.topRow setContentSize:CGSizeMake(_viewTopRow.frame.size.width, _viewTopRow.frame.size.height)];
  [self.topRow setFrame:CGRectMake(self.leftColWidth, frameSpreadSheet.origin.y, frameSpreadSheet.size.width-self.leftColWidth, _viewTopRow.frame.size.height)];
}

- (void) setTopRowDimensions {
  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  
  SpreadSheetArea * _viewTopRow = [[self.topRow subviews] objectAtIndex:0];
  [self.topRow setContentSize:CGSizeMake(_viewTopRow.frame.size.width, _viewTopRow.frame.size.height)];
  [self.topRow setFrame:CGRectMake(self.leftColWidth, frameSpreadSheet.origin.y, frameSpreadSheet.size.width-self.leftColWidth, _viewTopRow.frame.size.height)];
}

- (void) setLeftColViewAndData {

  [self.leftCol setDirectionalLockEnabled:YES];
  [self.leftCol setBounces:NO];
  SpreadSheetArea * _viewLeftCol = [[[SpreadSheetArea alloc] initColWithData:self.data.leftCol] autorelease];
  [self.leftCol addSubview:_viewLeftCol];

  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  [self.leftCol setContentSize:CGSizeMake(_viewLeftCol.frame.size.width, _viewLeftCol.frame.size.height)];
  [self.leftCol setFrame:CGRectMake(frameSpreadSheet.origin.x, self.topRowHeight, _viewLeftCol.frame.size.width, frameSpreadSheet.size.height-self.topRowHeight)];
}

- (void) setLeftColDimensions {

  SpreadSheetArea * _viewLeftCol = [[self.leftCol subviews] objectAtIndex:0];
  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  [self.leftCol setContentSize:CGSizeMake(_viewLeftCol.frame.size.width, _viewLeftCol.frame.size.height)];
  [self.leftCol setFrame:CGRectMake(frameSpreadSheet.origin.x, self.topRowHeight, _viewLeftCol.frame.size.width, frameSpreadSheet.size.height-self.topRowHeight)];
}

- (void) setCellData {

  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  CGRect _frame = CGRectMake(frameSpreadSheet.origin.x, frameSpreadSheet.origin.y, self.leftColWidth, self.topRowHeight);
  SpreadSheetCellView * _viewCell = [[[SpreadSheetCellView alloc] initWithFrame:_frame andData: self.data.cell] autorelease];
  [self.cell addSubview: _viewCell];
  
  [self setCellDimensions];
}

- (void) setCellDimensions {

  CGRect frameSpreadSheet = [[SpreadSheetProperties sharedSpreadSheetProperties] frame];
  CGRect _rect = CGRectMake(frameSpreadSheet.origin.x, frameSpreadSheet.origin.x, self.leftColWidth, self.topRowHeight);
  [self.cell setFrame:_rect];
}

- (void) updateCell {

  SpreadSheetCellView * _viewCell = [[self.cell subviews] objectAtIndex:0];
  [_viewCell setCellData:self.data.cell];
  [_viewCell updateCell];
}

- (void) updateTableAndViews {

  [self.delegate spreadSheetWillBeginRefreshing]; 
  
  SpreadSheetArea * _viewTopRow = (SpreadSheetArea *)[self.topRow.subviews objectAtIndex:0];
  [_viewTopRow updateRowWithData: self.data.topRow];
  self.topRowHeight = _viewTopRow.frame.size.height;
  self.topRowWidth = _viewTopRow.frame.size.width;
  
  SpreadSheetArea * _viewLeftCol = (SpreadSheetArea *)[self.leftCol.subviews objectAtIndex:0];
  [_viewLeftCol updateColWithData: self.data.leftCol];
  self.leftColWidth = _viewLeftCol.frame.size.width;
  self.leftColHeight = _viewLeftCol.frame.size.height; 
    
  [self.tableView reloadData];
  
  [self.delegate spreadSheetDidEndRefreshing];
}

- (void) updateDimensions {

  [self setLeftColDimensions];
  [self setTopRowDimensions];
  [self setTableDimenstions];
  [self setCellDimensions];
}

- (void) updateTableViewsDimensions {
  
  [self updateTableAndViews];
  [self updateDimensions];
  [self updateCell];
}

- (void) registerNotifications {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTapped:) name:kCellSingleTap object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesBegan:) name:kNotificationDoubleTouchesBegan object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesMoved:) name:kNotificationDoubleTouchesMoved object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesEnded:) name:kNotificationDoubleTouchesEnded object:nil];  
}

- (void) cellTapped: (NSNotification *)note {
  
  CellData * _cell = [note.userInfo objectForKey:@"CellData"];
  
  [[SpreadSheetProperties sharedSpreadSheetProperties] setSelectedCell: _cell];
  [[SpreadSheetProperties sharedSpreadSheetProperties] setSelectedRow:_cell.point.h];
  [[SpreadSheetProperties sharedSpreadSheetProperties] setSelectedCol:_cell.point.v];
  
  NSLog(@"cell [%d; %d] tapped", _cell.point.h, _cell.point.v);
  
  switch (_cell.cellType) {
    case cellTypeLeftCol:
      [self openActionSheetForRow];
      break;
    case cellTypeTopRow:
      [self openActionSheetForCol];
      break;

    case cellTypeSimple:
      [self openActionSheetForCell];
      break;
      
    default:
      break;
  }
}

- (void) touchesBegan: (NSNotification *)note {
  
  NSLog(@"touchesBegan");
}


- (void) touchesMoved: (NSNotification *)note {
  
  NSNumber * _x1 = [note.userInfo objectForKey:@"x1"];
  NSNumber * _y1 = [note.userInfo objectForKey:@"y1"];
  NSNumber * _x2 = [note.userInfo objectForKey:@"x2"];
  NSNumber * _y2 = [note.userInfo objectForKey:@"y2"];
  
  NSLog(@"(%f; %f) - (%f; %f)", [_x1 floatValue], [_y1 floatValue], [_x2 floatValue], [_y2 floatValue]);
}


- (void) touchesEnded: (NSNotification *)note {
  
  
}

@end


@implementation SpreadSheetViewController

@synthesize leftColWidth=leftColWidth_;
@synthesize leftColHeight=leftColHeight_;

@synthesize topRowWidth=topRowWidth_;
@synthesize topRowHeight=topRowHeight_;

@synthesize draggingTable=draggingTable_;
@synthesize draggingRow=draggingRow_;
@synthesize draggingCol=draggingCol_;

@synthesize tableView=tableView_;

@synthesize leftCol=leftCol_;
@synthesize topRow=topRow_;
@synthesize cell=cell_;

@synthesize data=data_;
@synthesize delegate=delegate_;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];

  SpreadSheetAppDelegate * _applicationDelegate = (SpreadSheetAppDelegate *)[[UIApplication sharedApplication] delegate];
  SnoopWindow * snoopWindow = (SnoopWindow *)_applicationDelegate.window;
  [snoopWindow setTableView: self.tableView];
  
  [[SpreadSheetProperties sharedSpreadSheetProperties] setFrame:self.view.frame];
  
  self.data = [[TableData alloc] initWithFakeData];
 
  [self settingLeftColWidth];
  [self settingTopRowHeight];

  [self setLeftColViewAndData];
  [self setTopRowViewAndData];
  [self setCellData];
  [self setTableSettings];
 
  [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  
  NSLog(@"viewWillAppear - finish");
}

/*
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
    return YES;
  }
  return NO;
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row < [[self.data leftCol] count]) {
    CellData * cell = [[self.data leftCol] objectAtIndex:indexPath.row];
    return [cell height];
  }
  return [[SpreadSheetProperties sharedSpreadSheetProperties] cellDefaultHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
/*
  // I do not not why the view rotates - need to figure out what is going on
  // this cose is just to contunte - I know exactly that width is bigger that height
  if (self.view.frame.size.width < self.view.frame.size.height) {
    CGRect _frame = self.view.frame;
    _frame.size.width = self.view.frame.size.height;
    _frame.size.height = self.view.frame.size.width;
    [self.view setFrame:_frame];
    NSLog(@"this is it");
  }
*/  
  return [self.data.leftCol count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString * spotCellIdentifier = @"SpreadSheetCell";
    
  NSArray * _rowData = [self.data.rows objectAtIndex: indexPath.row];

	SpreadSheetCell * cell = (SpreadSheetCell *)[tableView dequeueReusableCellWithIdentifier: spotCellIdentifier];
	if (cell == nil) {
    cell = [[[SpreadSheetCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: spotCellIdentifier withData: _rowData] autorelease];
  }
  [cell updateRowData: _rowData];

  CGFloat _height = [[self.data.leftCol objectAtIndex: indexPath.row] height];
  CGRect _frame = [cell.contents frame];
  _frame.size.height = _height;
  // if needed updating frame
  if (!CGRectEqualToRect([cell.contents frame], _frame)) {
    [cell.contents setFrame:_frame];
  }
  
  return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
  if (scrollView == tableView_) {
    [self setDraggingTable: YES];
    [self setDraggingCol: NO];
    [self setDraggingRow: NO];
  } else if (scrollView == leftCol_) {
    [self setDraggingTable: NO];
    [self setDraggingCol: YES];
    [self setDraggingRow: NO];
  } else if (scrollView == topRow_) {
    [self setDraggingTable: NO];
    [self setDraggingCol: NO];
    [self setDraggingRow: YES]; 
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {  

  if (scrollView == tableView_) {
    [self setDraggingTable:NO];
  } else if (scrollView == leftCol_) {
    [self setDraggingCol: NO];
  } else if (scrollView == topRow_) {
    [self setDraggingRow: NO];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  if (scrollView == tableView_) {
    
    CGPoint horizontalOffset = CGPointMake(tableView_.contentOffset.x, 0.0);
    CGPoint verticalOffset = CGPointMake(0.0, tableView_.contentOffset.y);

    if (![self draggingCol]) {
      [leftCol_ setContentOffset:verticalOffset animated:NO];
    }
    if (![self draggingRow]) {
      [topRow_ setContentOffset:horizontalOffset animated:NO];
    }
    
  } else if (scrollView == leftCol_) {
    if (![self draggingTable]) {
      CGPoint _offset = scrollView.contentOffset;
      _offset.x = self.tableView.contentOffset.x;
      [tableView_ setContentOffset:_offset animated: NO];
    }
  } else if (scrollView == topRow_) {
    if (![self draggingTable]) {
      CGPoint _offset = scrollView.contentOffset;
      _offset.y = self.tableView.contentOffset.y;
      [tableView_ setContentOffset:_offset animated: NO];
    }
  }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}
/*
- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}
*/
 
#pragma mark -
#pragma mark CellsActions

- (void) selectCellByCol: (NSInteger) _colNumber andRow: (NSInteger) _rowNumber {

  [self.data deselectAll];
  
  Rect _rect = {_rowNumber, _colNumber, _rowNumber, _colNumber};
  [self.delegate spreadSheetWillBeginSelection:_rect];
  
  Point _point = {_colNumber, _rowNumber};
  [self.data selectCell: _point];
  [self updateTableAndViews];
  
  [self.delegate cellClick: _point];
  
  [self.delegate spreadSheetDidEndSelection: _rect];
}

- (void) updateCellByCol: (NSInteger) _colNumber andRow: (NSInteger) _rowNumber {
  
  Point _point = {_colNumber, _rowNumber};
  CellData * _cell = [self.data getCellFromPoint: _point];
  
  [_cell setColor: [UIColor magentaColor]];
  [_cell setFont: [UIFont italicSystemFontOfSize: 24]];
  [_cell setBgColor: [UIColor blackColor]];
  [_cell setThickness: 3.0];
  [_cell setLabelAlignment: UITextAlignmentLeft];
 
  [self updateTableAndViews];
}

- (void) deselectAll {
  
  [self.data deselectAll];
  [self updateTableAndViews];
}

#pragma mark -
#pragma mark RowsActions

- (void) selectRow: (NSInteger) _rowNumber {
  
  [self.data deselectAll];
  
  Rect _rect = {_rowNumber, 0, _rowNumber, [self.data.topRow count]};
  [self.delegate spreadSheetWillBeginSelection:_rect];
  
  [self.data selectRow: _rowNumber];
  [self updateTableAndViews];
  
  [self.delegate rowClick: _rowNumber];
  
  [self.delegate spreadSheetDidEndSelection: _rect];
}

- (void) setRows: (NSArray *) _rows hidden: (BOOL) _hidden { 
  
  for (NSNumber * _number in _rows) {
    [self.data setRow:[_number intValue] hidden:_hidden];
  }
  
  [self.tableView reloadData];
  
  [(SpreadSheetArea *)[self.leftCol.subviews objectAtIndex:0] updateColWithData:self.data.leftCol];
  
  [self setTableDimenstions];
  [self setLeftColDimensions];
}

- (void) setRowAsHeader: (NSInteger) _rowNumber {
  
  [self setRows:[NSArray arrayWithObject:[NSNumber numberWithInt:_rowNumber]] hidden: YES];
  [self.data setRowAsTop: _rowNumber];
  [self updateTableViewsDimensions];
}

- (void) updateRow: (NSInteger) _rowNumber {
  
  RowColData * _row = [self.data getRowForIndex: _rowNumber];
  
  [_row setColor: [UIColor magentaColor]];
  [_row setFont: [UIFont italicSystemFontOfSize: 24]];
  [_row setBackGroundColor: [UIColor blackColor]];
  [_row setBorderThickness: 3.0];
  [_row setTextAligment: UITextAlignmentLeft];
  
  [self updateTableAndViews];
}

- (void) setRow: (NSInteger) _rowNumber height: (CGFloat) _height {
  
  [self.data setRow:_rowNumber height:_height];
  [self updateTableViewsDimensions];
}

#pragma mark -
#pragma mark ColumnActions
- (void) sortSpreadSheetByColumn: (NSInteger) _columnNumber {

  [self.data sortRowsByColumn: _columnNumber];
  [self updateTableAndViews];
}

- (void) selectColumn: (NSInteger) _columnNumber {
  
  [self.data deselectAll];
  
  Rect _rect = {0, _columnNumber, [self.data.leftCol count], _columnNumber};
  [self.delegate spreadSheetWillBeginSelection: _rect];
  
  [self.data selectCol: _columnNumber];
  [self updateTableAndViews];
  
  [self.delegate columnClick: _columnNumber];
  
  [self.delegate spreadSheetDidEndSelection: _rect];
}

- (void) setColumns: (NSArray *) _columns hidden: (BOOL) _hidden {
  
  for (NSNumber * _number in _columns) {
    [self.data setCol:[_number intValue] hidden: _hidden];
  }
  
  [self.tableView reloadData];
  [(SpreadSheetArea *)[self.topRow.subviews objectAtIndex:0] updateRowWithData:self.data.topRow];
  [self setTableDimenstions];
  [self setTopRowDimensions];
}

- (void) setColumnAsHeader: (NSInteger) _columnNumber {
  
  [self setColumns:[NSArray arrayWithObject:[NSNumber numberWithInt:_columnNumber]] hidden: YES];
  [self.data setColAsLeft: _columnNumber];
  [self updateTableViewsDimensions];
}

- (void) updateCol: (NSInteger) _colNumber {
  
  RowColData * _col = [self.data getColForIndex: _colNumber];
  
  [_col setColor: [UIColor magentaColor]];
  [_col setFont: [UIFont italicSystemFontOfSize: 24]];
  [_col setBackGroundColor: [UIColor blackColor]];
  [_col setBorderThickness: 3.0];
  [_col setTextAligment: UITextAlignmentLeft];
  
  [self updateTableAndViews];
}

- (void) setCol: (NSInteger) _colNumber width: (CGFloat) _width {
  
  [self.data setCol:_colNumber width:_width];
  [self updateTableViewsDimensions];
}

#pragma mark -
#pragma mark ActionSheet - for testing purposes

- (void) openActionSheetForCol {
  
  actionSheetType_ = actionSheetCol;
  
  UIActionSheet *options = [[[UIActionSheet alloc] initWithTitle:@"Column:" 
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Select", @"Sort", @"Hide", @"Set As Header", @"Update", @"Set Width", nil] autorelease];
  [options showInView:self.view];
}

- (void) openActionSheetForRow {
  
  actionSheetType_ = actionSheetRow;
  
  UIActionSheet *options = [[[UIActionSheet alloc] initWithTitle:@"Row:" 
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Select", @"Hide", @"Set As Header", @"Update", @"Set Height", nil] autorelease];
  [options showInView:self.view];
}

- (void) openActionSheetForCell {
  
  actionSheetType_ = actionSheetCell;
  
  UIActionSheet *options = [[[UIActionSheet alloc] initWithTitle:@"Cell:" 
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                              	otherButtonTitles:@"Select", @"Update", @"DeSelect All", nil] autorelease];
  [options showInView:self.view];
}

- (void) proceedActionWithColForButtonIndex:(NSInteger) buttonIndex {
  
  NSInteger _colIndex = [[SpreadSheetProperties sharedSpreadSheetProperties] selectedCol];
  
  switch (buttonIndex) {
    case 0:
      [self selectColumn: _colIndex];
      break;
    case 1:
      [self sortSpreadSheetByColumn:_colIndex];
      break;
    case 2: {
      NSArray * _colsToHide = [NSArray arrayWithObject:[NSNumber numberWithInt:_colIndex]];
      [self setColumns:_colsToHide hidden: YES];
    } break;
    case 3:
      [self setColumnAsHeader: _colIndex];
      break;
    case 4:
      [self updateCol:_colIndex];
      break;
    case 5:
      [self setCol:_colIndex width:99];
      break;
      
    default:
      break;
  }
}

- (void) proceedActionWithRowForButtonIndex:(NSInteger) buttonIndex {
  
  NSInteger _rowIndex = [[SpreadSheetProperties sharedSpreadSheetProperties] selectedRow];
  
  switch (buttonIndex) {
    case 0:
      [self selectRow:_rowIndex];
      break;
    case 1: {
      NSArray * _rowsToHide = [NSArray arrayWithObject:[NSNumber numberWithInt:_rowIndex]];
      [self setRows: _rowsToHide hidden: YES];
    } break;
    case 2:
      [self setRowAsHeader:_rowIndex];
      break;
    case 3:
      [self updateRow:_rowIndex];
      break;
    case 4:
      [self setRow:_rowIndex height:37];
      break;
      
    default:
      break;
  }
}

- (void) proceedActionWithCellForButtonIndex:(NSInteger) buttonIndex {
  
  NSInteger _colIndex = [[SpreadSheetProperties sharedSpreadSheetProperties] selectedCol];
  NSInteger _rowIndex = [[SpreadSheetProperties sharedSpreadSheetProperties] selectedRow];
  
  switch (buttonIndex) {
    case 0:
      [self selectCellByCol: _colIndex andRow: _rowIndex];
      break;
    case 1:
      [self updateCellByCol: _colIndex andRow: _rowIndex];
      break;
    case 2:
      [self deselectAll];
      break;
      
    default:
      break;
  }
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

  switch (actionSheetType_) {
    case actionSheetCol:
      [self proceedActionWithColForButtonIndex: buttonIndex];
      break;
    case actionSheetRow:
      [self proceedActionWithRowForButtonIndex: buttonIndex];
      break;
    case actionSheetCell:
      [self proceedActionWithCellForButtonIndex: buttonIndex];
      break;
    
    default:
      break;
  }
}

- (void)dealloc {

  [leftCol_ release];
  [topRow_ release];
  [data_ release];
  
  [super dealloc];
}


@end

