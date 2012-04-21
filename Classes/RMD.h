#import <UIKit/UIkit.h>

/*
The RMD class contains methods to calculate RMD */
@interface RMD : NSObject
{
	NSDate* bd;
	double bal, rmd;
	int year;
}

+ (RMD*) ret;
- (void)setBD:(NSDate*)b;
- (void)setBal:(double)c;
- (void)setYear:(int)y;
- (int)year;
- (NSDate*)bd;
- (int)age;
- (double)rmd;
@end