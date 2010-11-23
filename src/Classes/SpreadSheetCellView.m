//
//  SpreadSheetCellView.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/30/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetCellView.h"
#import "ImageLibrary.h"
#import "SpreadSheetProperties.h"
#import "Constants.h"

@interface SpreadSheetCellView (Private)

- (void) setBorders;
- (void) setCellBackGroundColor;

@end

@implementation SpreadSheetCellView (Private)

- (void) setBorders {
  
  CGRect frame = [self.contents frame];
  
  int lineThickness = self.cellData.thickness;
  
  if ([self.cellData cellType] == cellTypeTopRow) {
    frame.origin.x = lineThickness;
    frame.origin.y = lineThickness;
    frame.size.width  -= lineThickness;
    frame.size.height -= 2*lineThickness;
  } else if ([self.cellData cellType] == cellTypeLeftCol) {
    frame.origin.x = lineThickness;
    frame.origin.y = lineThickness;
    frame.size.width  -= 2*lineThickness;
    frame.size.height -= lineThickness;
  } else if ([self.cellData cellType] == cellTypeTopLeft) {
    frame.origin.x = lineThickness;
    frame.origin.y = lineThickness;
    frame.size.width  -= 2*lineThickness;
    frame.size.height -= 2*lineThickness;
  } else if ([self.cellData cellType] == cellTypeSimple) {
    frame.origin.x = lineThickness;
    frame.origin.y = lineThickness;
    frame.size.width  -= lineThickness;
    frame.size.height -= lineThickness;
  }

  [background_ setFrame:frame];
  [label_ setFrame:frame];
  
  if (self.cellData.color) {
    [label_ setTextColor:self.cellData.color];
  } else {
    [label_ setTextColor: [UIColor blackColor]];
  }

  [label_ setTextAlignment:self.cellData.labelAlignment];
  
  [button_ setFrame:frame];
}

- (void) setCellBackGroundColor {
  
  if ([self isHeader]) {
    if ([self isSelected]) {
      [self.background setBackgroundColor: [[SpreadSheetProperties sharedSpreadSheetProperties] colorHeaderSelected]];
    } else {
      [self.background setBackgroundColor: [[SpreadSheetProperties sharedSpreadSheetProperties] colorHeaderNormal]];
    }
  } else {
    if ([self isSelected]) {
      [self.background setBackgroundColor: [[SpreadSheetProperties sharedSpreadSheetProperties] colorCellSelected]];
    } else {
      if (self.cellData.bgColor) {
        [self.background setBackgroundColor:self.cellData.bgColor];
      } else {
        [self.background setBackgroundColor:[UIColor grayColor]];
      }
    }
  }
}

@end


@implementation SpreadSheetCellView

@synthesize contents=contents_;
@synthesize background=background_;
@synthesize label=label_;
@synthesize button=button_;
@synthesize imageView=imageView_;

@synthesize cellData=cellData_;

- (id)initWithFrame:(CGRect)frame andData: (CellData *) _cellData {
  
  if ((self = [super initWithFrame:frame])) {
    [[NSBundle mainBundle] loadNibNamed:@"SpreadSheetCellView" owner:self options:nil];

    [self setCellData: _cellData];
    
    frame.origin.x = 0;
    frame.origin.y = 0;
    [contents_ setFrame:frame];    
    [self addSubview:contents_];

    [self performSelector:@selector(setBorders) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(setCellBackGroundColor) withObject:nil afterDelay: 0.0];
    
    [self updateCell];
  }
  return self;
}

- (IBAction) cellTapped {

  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.cellData forKey:@"CellData"];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCellSingleTap  object:nil userInfo:userInfo];
}
  
- (void) updateCell {

  [self.label setFont:[self.cellData font]];
  if ([self.cellData isString]) {
    [self.label setText: (NSString *)[self.cellData value]];
  } else if ([self.cellData isNumber]) {
    [self.label setText:[NSString stringWithFormat:@"%@", [(NSNumber *)[self.cellData value] stringValue]]];
  } else if ([self.cellData isDate]) {
    
  }
  [self updateImage];
  [self setBorders];
  [self setCellBackGroundColor];
}

- (void) setSelected: (BOOL) _selected {
  
  if (self.cellData.isSelected != _selected) {
    [self.cellData setSelected: _selected];
    [self setCellBackGroundColor];
  }
}

- (void) updateImage {
  
  if (self.cellData.imageIndex>=0) {
    [self.imageView setImage:[[ImageLibrary sharedImageLibrary] getImageForIndex:self.cellData.imageIndex]];
    CGRect frame = [self.contents frame];

    frame.origin.x += 3;
    frame.origin.y += 3;
    frame.size.width -= 6; 
    frame.size.height -= 6; 
    
    [self.imageView setFrame:frame];
    [self.imageView setContentMode:self.cellData.imageViewAligment];
  }
}

- (BOOL) isSelected {
  return [self.cellData isSelected];
}

- (BOOL) isHeader {
  return [self.cellData isHeader];
}

- (void)dealloc {
  
  [contents_ release];
  [background_ release];
  [label_ release];
  [button_ release];
  
  [super dealloc];
}


@end
