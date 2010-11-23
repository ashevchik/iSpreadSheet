//
//  SpreadSheetAppDelegate.h
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpreadSheetViewController.h"


@interface SpreadSheetAppDelegate : NSObject <UIApplicationDelegate, SpreadSheetDelegate> {
  
  UIWindow * window;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;

@end

