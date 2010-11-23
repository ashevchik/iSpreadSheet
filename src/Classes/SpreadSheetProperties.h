//
//  SpreadSheetProperties.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/16/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "CellData.h"

@interface SpreadSheetProperties : NSObject {

@private
  
  // predefined fonts:
  UIColor * colorCellSelected_;
  UIColor * colorCellNormal_;
  UIColor * colorHeaderSelected_;
  UIColor * colorHeaderNormal_;
  
  // default width and height of the cell
  CGFloat cellDefaultWidth_;
  CGFloat cellDefaultHeight_;
  
  // column index to sort for
  NSInteger selectedCol_;
  // column index to sort for
  NSInteger selectedRow_;
  // selected cell
  CellData * selectedCell_;

  CGRect frame_;
}

+ (SpreadSheetProperties *) sharedSpreadSheetProperties;

@property (nonatomic, retain) UIColor * colorCellSelected;
@property (nonatomic, retain) UIColor * colorCellNormal;
@property (nonatomic, retain) UIColor * colorHeaderSelected;
@property (nonatomic, retain) UIColor * colorHeaderNormal;

@property (readwrite) CGFloat cellDefaultWidth;
@property (readwrite) CGFloat cellDefaultHeight;

@property (readwrite) NSInteger selectedCol;
@property (readwrite) NSInteger selectedRow;

@property (nonatomic, retain) CellData * selectedCell;

@property (readwrite) CGRect frame;

@end
