/*
 * Copyright (c) 2011 Bryce Campbell. All Rights Reserved.
 */
#import <UIKit/UIkit.h>

/*
The RMD class contains methods to calculate RMD */
@interface RMD : NSObject
{
	NSDate* bd; // variable to hold birth day
	double bal, rmd; // variables to hold RMD results and account balance
	int year; // variable to hold year of distribution
}

+ (RMD*) ret;
// the following are setter methods to hold necessary data
- (void)setBD:(NSDate*)b;
- (void)setBal:(double)c;
- (void)setYear:(int)y;
// the following are accessor methods to retrieve most of the values entered
- (int)year;
- (NSDate*)bd;
- (int)age;
- (double)rmd;
@end