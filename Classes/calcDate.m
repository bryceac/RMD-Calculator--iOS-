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
- (int)year
{
    /* get previous year */
	/* return year -1; */
    
    /* get current year */
    return year;
}
- (int)month
{
	return month;
}
- (int)day
{
	return day;
}
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

- (void) dealloc
{
	[self setYear:0];
	[self setMonth:0];
	[self setDay:0];
	
	[super dealloc]; // free memory
}
@end