//
//  SpreadSheetProperties.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/16/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetProperties.h"

@implementation SpreadSheetProperties

SYNTHESIZE_SINGLETON_FOR_CLASS(SpreadSheetProperties)

@synthesize colorCellSelected=colorCellSelected_;
@synthesize colorCellNormal=colorCellNormal_;
@synthesize colorHeaderSelected=colorHeaderSelected_;
@synthesize colorHeaderNormal=colorHeaderNormal_;

@synthesize cellDefaultWidth=cellDefaultWidth_;
@synthesize cellDefaultHeight=cellDefaultHeight_;

@synthesize selectedCol=selectedCol_;
@synthesize selectedRow=selectedRow_;
@synthesize selectedCell=selectedCell_;

@synthesize frame=frame_;

- (id) init {
  if (self = [super init]) {
    // default properties
    [self setColorCellNormal: [UIColor whiteColor]];
    [self setColorCellSelected: [UIColor redColor]];

    [self setColorHeaderNormal:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0]];
    [self setColorHeaderSelected: [UIColor blueColor]];
    
    [self setCellDefaultWidth: 100.0];
    [self setCellDefaultHeight: 20.0];
  }
  return self;
}


@end
