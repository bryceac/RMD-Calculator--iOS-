//
//  DBPath.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBPath.h"
#import "RMD_CalculatorAppDelegate.h"

@implementation DBPath

+(NSString*)getDBPath
{
    NSString *dbpath = [(RMD_CalculatorAppDelegate *)[[UIApplication sharedApplication] delegate] dbpath];
    
    return dbpath;
}
@end
