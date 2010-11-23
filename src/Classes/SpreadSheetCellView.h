//
//  SpreadSheetCellView.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/30/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellData.h"

@interface SpreadSheetCellView : UIView {

@private
  
  UIView * contents_;
  UIView * background_;
  UILabel * label_;
  UIButton * button_;
  
  UIImageView * imageView_;
  
  CellData * cellData_;
}

@property (nonatomic, retain) IBOutlet UIView * contents;
@property (nonatomic, retain) IBOutlet UIView * background;
@property (nonatomic, retain) IBOutlet UILabel * label;
@property (nonatomic, retain) IBOutlet UIButton * button;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

@property (nonatomic, assign) CellData * cellData;

- (IBAction) cellTapped;

- (id)initWithFrame:(CGRect)frame andData: (CellData *) _cellData;

- (void) updateImage;
- (void) updateCell;


- (void) setSelected: (BOOL) _selected;
- (BOOL) isSelected;

- (BOOL) isHeader;

@end
