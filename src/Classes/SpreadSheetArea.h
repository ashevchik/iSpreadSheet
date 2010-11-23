//
//  SpreadSheetArea.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpreadSheetArea : UIView {
}

- (id) initRowWithData: (NSArray *) _data;
- (id) initColWithData: (NSArray *) _data;
- (id) initRectWithData: (NSArray *) _data; 

- (void) updateColWithData: (NSArray *) _data;
- (void) updateRowWithData: (NSArray *) _data;

@end
