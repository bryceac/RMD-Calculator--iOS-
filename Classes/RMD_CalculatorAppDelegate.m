//
//  RMD_CalculatorAppDelegate.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/25/11.
//  Copyright 2011 Bryce Campbell. All rights reserved.
//

#import "RMD_CalculatorAppDelegate.h"
#import "RMD_CalculatorViewController.h"

@implementation RMD_CalculatorAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // create database
    sqlite3 *mrdDB;
    NSString* dbpath;
    NSString *docsDir;
    NSArray *dirPaths;
    
    // get document directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // build path to database
    dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"mrd.db"]];
    
    NSFileManager *manage = [NSFileManager defaultManager];
    
    if ([manage fileExistsAtPath:dbpath] == NO) 
    {
        const char *dpath = [dbpath UTF8String];
        
        if (sqlite3_open(dpath, &mrdDB) == SQLITE_OK) 
        {
            char **errMessage;
            const char *sql = "CREATE TABLE IF NOT EXISTS rmd (id INTEGER PRIMARY KEY AUTOINCREMENT, birth TEXT, bal REAL, year INTEGER)";
            if (sqlite3_exec(mrdDB, sql, NULL, NULL, errMessage) != SQLITE_OK)
            {
                    
            }
            
            sqlite3_close(mrdDB);
            
        } else;
    }
    
    [manage release];

	// Set the view controller as the window's root view controller and display.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
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
    [viewController release];
    [window release];
    [super dealloc];
}


@end
