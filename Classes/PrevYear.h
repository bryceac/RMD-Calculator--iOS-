//
//  PrevYear.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 8/21/12.
//
//

#import <Foundation/Foundation.h>

@interface PrevYear : NSObject
{
    int iyear;
}

- (void)setIYear:(NSString *)p;
- (int)prevYear;
@end
