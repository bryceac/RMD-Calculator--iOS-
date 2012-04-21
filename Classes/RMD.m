#import "RMD.h"
#import "calcDate.h"
@implementation RMD

- (id) init
{
	if (self = [super init])
	{
		[self setBD:nil];
		[self setBal:0];
		[self setYear:0];
	}
	return self;
}
+ (RMD*) ret
{
	RMD* newRMD = [[RMD alloc] init]; // create instance or RMD
	return [newRMD autorelease]; // release object and free memory
}	
- (void)setBD:(NSDate*)b
{
	bd = b;
}
- (void)setBal:(double)c
{
	bal = c;
}
- (void)setYear:(int)y
{
	year = y;
}

- (int)year
{
	return year;
}

- (NSDate*)bd
{
	return bd;
}
- (int)age
{
	calcDate* calc = [[calcDate alloc] init];
	[calc setYear:[self year]];
	[calc setMonth:12];
	[calc setDay:31];

	NSTimeInterval seconds = [[calc start] timeIntervalSinceDate:[self bd]];

	int days = seconds/86400;
	int age = days/365;
    [calc release];
	return age;
}
- (double)rmd
{
	switch([self age])
	{
		case 70: rmd = bal/27.4; break;

		case 71: rmd = bal/26.5; break;

		case 72: rmd = bal/25.6; break;

		case 73: rmd = bal/24.7; break;

		case 74: rmd = bal/23.8; break;
		case 75: rmd = bal/22.9; break;
		case 76: rmd = bal/22.0; break;
		case 77: rmd = bal/21.2; break;
		case 78: rmd = bal/20.3; break;
		case 79: rmd = bal/19.5; break;
		case 80: rmd = bal/18.7; break;
		case 81: rmd = bal/17.9; break;
		case 82: rmd = bal/17.1; break;
		case 83: rmd = bal/16.3; break;
		case 84: rmd = bal/15.5; break;
		case 85: rmd = bal/14.8; break;
		case 86: rmd = bal/14.1; break;
		case 87: rmd = bal/13.4; break;
		case 88: rmd = bal/12.7; break;
		case 89: rmd = bal/12.0; break;
		case 90: rmd = bal/11.4; break;
		case 91: rmd = bal/10.8; break;
		case 92: rmd = bal/10.2; break;
		case 93: rmd = bal/9.6; break;
		case 94: rmd = bal/9.1; break;
		case 95: rmd = bal/8.6; break;
		case 96: rmd = bal/8.1; break;
		case 97: rmd = bal/7.6; break;
		case 98: rmd = bal/7.1; break;
		case 99: rmd = bal/6.7; break;
		case 100: rmd = bal/6.3; break;
		case 101: rmd = bal/5.9; break;
		case 102: rmd = bal/5.5; break;
		case 103: rmd = bal/5.2; break;
		case 104: rmd = bal/4.9; break;
		case 105: rmd = bal/4.5; break;
		case 106: rmd = bal/4.2; break;
		case 107: rmd = bal/3.9; break;
		case 108: rmd = bal/3.7; break;
		case 109: rmd = bal/3.4; break;
		case 110: rmd = bal/3.1; break;
		case 111: rmd = bal/2.9; break;
		case 112: rmd = bal/2.6; break;
		case 113: rmd = bal/2.4; break;
		case 114: rmd = bal/2.1; break;
		
		default:
		if([self age] >= 115)
		{ 
			rmd = bal/1.9;
		}
		else
		{
			rmd = 0.0; 
		}
		break;

	}
	return rmd;
}
- (void) dealloc
{
	[self setBD:nil];
	[self setBal:0];
	[self setYear:0];
	[super dealloc]; // free memory
}
@end