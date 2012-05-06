/*
 * Copyright (c) 2012 Bryce Campbell. All Rights Reserved.
*/
#import "calcDate.h"
@implementation calcDate

- (id) init
{
	if (self = [super init])
	{
		[self setYear:0]; /* set year to zero */
		[self setMonth:0]; /* set month */
		[self setDay:0]; /* set day */
	}
	return self;
}
+ (calcDate*) calcDate
{
	calcDate* newDate = [[calcDate alloc] init]; /* create instance of class */
	return [newDate autorelease]; /* return newDate object and free memory */
}

/* setter methods */
// the setYear method assigns a value to the year variable
- (void)setYear:(int)y
{
	year = y;
}
// the setMonth method assigns a value to the month variable
- (void)setMonth:(int)m
{
	month = m;
}
// the setDay method assigns a value to the day variable
- (void)setDay:(int)d
{
	day = d;
}

/* getter methods */
/* the year method, previously named PrevYear, because it returned the previous year, returns the year of distribution */
- (int)year
{
    /* get previous year */
	/* return year -1; */
    
    /* get current year */
    return year;
}
// the month method returned the value of the month variable
- (int)month
{
	return month;
}

// the day method returns the value of the day variable
- (int)day
{
	return day;
}

/* the start method returns a date that is used for age calculation based on the month, day, and year assigned to variables of this class */
- (NSDate*)start
{

	NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* date = [[NSDateComponents alloc] init];
	[date setYear:[self year]];
	[date setMonth:[self month]];
	[date setDay:[self day]];

	start = [cal dateFromComponents:date];
    [date release];
	[cal release];
	return start;
}

/* the following method releases the class from memory */
- (void) dealloc
{
	[self setYear:0];
	[self setMonth:0];
	[self setDay:0];
	
	[super dealloc]; // free memory
}
@end