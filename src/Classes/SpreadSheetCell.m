//
//  SpreadSheetCell.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 4/2/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetCell.h"
#import "SpreadSheetArea.h"
#import "CellData.h"
#import "Constants.h"

@interface SpreadSheetCell (Private)

- (void) createSpreadSheetAreaWithData: (NSArray *) _data;
- (void) updateCellWithData: (NSArray *) _data;

@end

@implementation SpreadSheetCell (Private)

- (void) createSpreadSheetAreaWithData: (NSArray *) _data {
  
  SpreadSheetArea * _view = [[[SpreadSheetArea alloc] initRowWithData: _data] autorelease];
  [self.contents addSubview:_view];
  
  CGRect frame = [_view frame];
   
  [self.contents setFrame:frame];
  [self setFrame:frame];
}

- (void) updateCellWithData: (NSArray *) _data {
  
  if ([[self.contents subviews] count]) {
    SpreadSheetArea * _viewCell = [[self.contents subviews] objectAtIndex:0];
    [_viewCell updateRowWithData: _data];
  }
}

@end


@implementation SpreadSheetCell

@synthesize contents=contents_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData: (NSArray *)_data {

	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {

		[[NSBundle mainBundle] loadNibNamed:@"SpreadSheetCell" owner:self options:nil];
    [self createSpreadSheetAreaWithData: _data];
		[self.contentView addSubview:contents_];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void) updateRowData:(NSArray *)_rowData {
  
  [self updateCellWithData: _rowData];
}

- (void)dealloc {

  [contents_ release];
  [super dealloc];
}

@end
