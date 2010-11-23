//
//  NSArray+Sort.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/12/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Sort) 

- (NSComparisonResult) compareWithArray: (NSMutableArray *) _array;

@end
