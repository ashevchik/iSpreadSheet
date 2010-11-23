//
//  ImageLibrary.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 10/12/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "ImageLibrary.h"


@implementation ImageLibrary

SYNTHESIZE_SINGLETON_FOR_CLASS(ImageLibrary)

- (id) init {
  if (self = [super init]) {
    UIImage * image1 = [UIImage imageNamed:@"arrow1.png"];
    UIImage * image2 = [UIImage imageNamed:@"arrow2.png"];
    UIImage * image3 = [UIImage imageNamed:@"arrow3.png"];
    images_ = [[NSMutableArray alloc] initWithObjects:image1, image2, image3, nil];
  }
  return self;
}

- (UIImage *) getImageForIndex: (NSInteger) _index {

  if (_index>=0 && _index<[images_ count]) {
    return [images_ objectAtIndex:_index];
  }
  return nil;
}

- (void) dealloc {
  
  [images_ release];
  [super dealloc];
}

@end
