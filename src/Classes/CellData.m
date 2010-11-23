//
//  CellData.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "CellData.h"

@implementation CellData

@synthesize width=width_;
@synthesize height=height_;
@synthesize value=value_;

@synthesize isHiddenAsRow=isHiddenAsRow_;
@synthesize isHiddenAsCol=isHiddenAsCol_;

@synthesize isSelected=isSelected_;
@synthesize isAlreadySorted=isAlreadySorted_;

@synthesize point=point_;
@synthesize cellType=cellType_;

@synthesize color=color_;
@synthesize font=font_;
@synthesize bgColor=bgColor_;
@synthesize thickness=thickness_;
@synthesize labelAlignment=labelAlignment_;

@synthesize imageViewAligment=imageViewAligment_;
@synthesize imageRect=imageRect_;
@synthesize imageIndex=imageIndex_;

- (id) initWithIndex: (Point) _point value: (id) _value width:(CGFloat) _width height: (CGFloat) _height cellType: (enCellType) _cellType {
  
  if (self = [super init]) {
    [self setPoint: _point];
    [self setWidth: _width];
    [self setHeight: _height];
    [self setValue: _value];
    [self setRowHidden: NO];
    [self setColHidden: NO];
    [self setCellType: _cellType];
    
    [self setColor: [UIColor blackColor]];
    if ([self isHeader]) {
      [self setBgColor: [UIColor grayColor]];
    } else {
      [self setBgColor: [UIColor whiteColor]];
    }
    [self setBgColor: [UIColor whiteColor]];
    [self setThickness: 1.0];
    [self setLabelAlignment: UITextAlignmentCenter];
    
    [self setImageIndex:-1];
    [self setImageViewAligment: UIViewContentModeLeft];
  }    
  return self;
}

- (id) initWithIndex: (Point) _point value: (id) _value width:(CGFloat) _width height: (CGFloat) _height {
  if (self = [self initWithIndex: _point value: _value width: _width height: _height cellType: cellTypeSimple]) {
  }    
  return self;
}

- (id) initFromCellData: (CellData *) _cellData {
  if (self = [self initWithIndex: _cellData.point value: _cellData.value width: _cellData.width height: _cellData.height cellType: _cellData.cellType]) {
  }    
  return self;
  
}

- (BOOL) isString {
  if ([self.value isKindOfClass:[NSString class]]) {
    return YES;
  }
  return NO;
}

- (BOOL) isNumber {
  if ([self.value isKindOfClass:[NSNumber class]]) {
    return YES;
  }
  return NO;
}

- (BOOL) isDate {
  if ([self.value isKindOfClass:[NSDate class]]) {
    return YES;
  }
  return NO;
}

- (BOOL) isHeader {
  if (self.cellType == cellTypeTopRow || self.cellType == cellTypeLeftCol || self.cellType == cellTypeTopLeft) {
    return YES;
  }
  return NO;
}

- (BOOL) isVisible {
  
  if (self.isHiddenAsRow == NO && self.isHiddenAsCol == NO) {
    return YES;
  }
  return NO;
}

- (NSComparisonResult) compareWithAnother: (CellData *) _anotherCell {
  
  if ([self isString] && [_anotherCell isString]) {
    return [(NSString *)self.value compare:(NSString *)_anotherCell.value];
  } else if ([self isNumber] && [_anotherCell isNumber]) {
    return [(NSNumber *)self.value compare:(NSNumber *)_anotherCell.value];
  } else if ([self isDate] && [_anotherCell isDate]) {
    return [(NSDate *)self.value compare:(NSDate *)_anotherCell.value];
  }
  
  return NSOrderedSame;
}

@end
