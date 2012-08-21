//
//  PrevYear.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 8/21/12.
//  Copyight 2012 Bryce Campbell. All Rights Reserved.
//

#import <Foundation/Foundation.h>

@interface PrevYear : NSObject
{
    int iyear;
}

- (void)setIYear:(NSString *)p;
- (int)prevYear;
@end
