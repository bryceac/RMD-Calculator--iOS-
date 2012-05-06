//
//  DBPath.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/26/12.
//  Copyright (c) 2012 Bryce Campbell. All rights reserved.
//

#import "DBPath.h"
#import "RMD_CalculatorAppDelegate.h" // import AppDelegate, in order to function properly

@implementation DBPath

// the getDBPath method retrieves the database path
+(NSString*)getDBPath
{
    NSString *dbpath = [(RMD_CalculatorAppDelegate *)[[UIApplication sharedApplication] delegate] dbpath];
    
    return dbpath;
}
@end
