//
//  CellData.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum enCellType {
  cellTypeSimple,
  cellTypeLeftCol,
  cellTypeTopRow,
  cellTypeTopLeft
} enCellType;


// the cell data storage class
@interface CellData : NSObject {
  @private 
  // width and height of the cell
  CGFloat width_;
  CGFloat height_;
  // value of the cell
  id value_;
  // flags 
  BOOL isSelected_;
  BOOL isHiddenAsRow_;
  BOOL isHiddenAsCol_;
  BOOL isAlreadySorted_;
  // x and y in the table
  Point point_; 
  // cell type
  enCellType cellType_;
  // color, background color and font of the label
  UIColor * color_;
  UIFont * font_;
  UIColor * bgColor_;
  // thickhess of the border
  CGFloat thickness_;
  // alignment of the label
  UITextAlignment labesAlignment_;
  // alignment of the image
  UIViewContentMode imageViewAligment_;
  // image geometry
  CGRect imageRect_;
  // image index
  NSInteger imageIndex_;
}

@property (readwrite) CGFloat width;
@property (readwrite) CGFloat height;
@property (nonatomic, retain) id value;

@property (readwrite, setter=setRowHidden) BOOL isHiddenAsRow;
@property (readwrite, setter=setColHidden) BOOL isHiddenAsCol;

@property (readwrite, setter=setSelected) BOOL isSelected;
@property (readwrite, setter=setAlreadySorted) BOOL isAlreadySorted;

@property (readwrite) enCellType cellType;
@property (readwrite) Point point;

@property (nonatomic, retain) UIColor * color;
@property (nonatomic, retain) UIFont * font;
@property (nonatomic, retain) UIColor * bgColor;
@property (readwrite) CGFloat thickness;
@property (readwrite) UITextAlignment labelAlignment;

@property (readwrite) UIViewContentMode imageViewAligment;
@property (readwrite) CGRect imageRect;
@property (readwrite) NSInteger imageIndex;


- (id) initWithIndex: (Point) _point value: (id) _value width:(CGFloat) _width height: (CGFloat) _height cellType: (enCellType) _cellType;
- (id) initWithIndex: (Point) _point value: (id) _value width:(CGFloat) _width height: (CGFloat) _height;

- (id) initFromCellData: (CellData *) _cellData;

- (BOOL) isString;
- (BOOL) isNumber;
- (BOOL) isDate;

- (BOOL) isHeader;
- (BOOL) isVisible;

- (NSComparisonResult) compareWithAnother: (CellData *) _anotherCell;

@end
