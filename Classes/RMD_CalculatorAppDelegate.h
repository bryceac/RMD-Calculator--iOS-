//
//  RMD_CalculatorAppDelegate.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class RMD_CalculatorViewController;

@interface RMD_CalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RMD_CalculatorViewController *viewController;
    NSString *dbname, *dbpath;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RMD_CalculatorViewController *viewController;
@property (nonatomic, strong) NSString *dbpath;
@property (nonatomic, strong) NSString *dbname;

-(void)createDB;
@end

