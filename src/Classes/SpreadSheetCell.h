//
//  SpreadSheetCell.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 4/2/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpreadSheetCell : UITableViewCell {
  @private

	UIView * contents_;
}

@property (nonatomic, retain) IBOutlet UIView * contents;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData: (NSArray *)_data;

- (void) updateRowData: (NSArray *) _rowData;

@end
