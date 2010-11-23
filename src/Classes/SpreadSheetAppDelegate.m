//
//  SpreadSheetAppDelegate.m
//  SpreadSheet
//
//  Created by Alexey Shevchik on 9/28/10.
//  Copyright 2010 SoftTeco. All rights reserved.
//

#import "SpreadSheetAppDelegate.h"

@implementation SpreadSheetAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

  NSLog(@"didFinishLaunchingWithOptions");
  
  SpreadSheetViewController * _controller = [[SpreadSheetViewController alloc] initWithNibName: @"SpreadSheetViewController" bundle: nil];
  [_controller setDelegate:self];
  [window addSubview:_controller.view];
  [window makeKeyAndVisible];
  
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
  [window release];
  [super dealloc];
}

- (void) rowClick: (NSInteger) _rowIndex {
  NSLog(@"rowClick: %d");
}

- (void) columnClick: (NSInteger) _columnIndex {
  NSLog(@"columnClick: %d");
}

- (void) cellClick: (Point) _cellPoint{
  NSLog(@"cellClick: (%d; %d)");
}

- (void) spreadSheetWillBeginRefreshing {
  NSLog(@"spreadSheetWillBeginRefreshing");
}

- (void) spreadSheetDidEndRefreshing {
  NSLog(@"spreadSheetDidEndRefreshing");
}

- (void) spreadSheetWillBeginSelection: (Rect) _selectionArea {
  NSLog(@"spreadSheetWillBeginSelection: (%d; %d; %d; %d)", _selectionArea.top, _selectionArea.right, _selectionArea.bottom, _selectionArea.right);
}

- (void) spreadSheetDidEndSelection: (Rect) _selectionArea {
  NSLog(@"spreadSheetDidEndSelection: (%d; %d; %d; %d)", _selectionArea.top, _selectionArea.right, _selectionArea.bottom, _selectionArea.right);
}
@end
