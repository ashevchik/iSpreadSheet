//
//  NSArray+Sort.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/12/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Sort.h"
#import "CellData.h"
#import "SpreadSheetProperties.h"

@implementation NSMutableArray (Sort) 

- (NSComparisonResult) compareWithArray: (NSMutableArray *) _array {
  
  NSInteger _columnNumber = [[SpreadSheetProperties sharedSpreadSheetProperties] selectedCol];
  
  if (_columnNumber>=0 && _columnNumber<[self count]) {

    CellData * _thisCell = [self objectAtIndex: _columnNumber];
    
    if (_columnNumber>=0 && _columnNumber<[_array count]) {
      
      CellData * _anotherCell = [_array objectAtIndex:_columnNumber];
      
      return [_thisCell compareWithAnother: _anotherCell];
    }
  }
  
  return NSOrderedSame;
}

@end
