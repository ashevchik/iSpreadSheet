//
//  ImageLibrary.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/12/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface ImageLibrary : NSObject {

  @private
  NSMutableArray * images_;
}

+ (ImageLibrary *) sharedImageLibrary;

- (UIImage *) getImageForIndex: (NSInteger) _index;

@end
