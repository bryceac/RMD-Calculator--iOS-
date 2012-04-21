#import <UIKit/UIKit.h>
/*
The predate class contains methods to get the previous year */
@interface calcDate : NSObject
{
	NSDate* start; // variable to hold calendar data
	int year, month, day; // variables to hold date informate
}

+ (calcDate*) calcDate;

// the following are setter method, to set Date
- (void)setYear:(int)y;
- (void)setMonth:(int)m;
- (void)setDay:(int)d;
// the following are accessor methods to retrieve data
- (int)year;
- (int)month;
- (int)day;
- (NSDate*)start;
@end