//
//  Data.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/22/15.
//
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

// the following methods all deal with saving data
- (BOOL*)DBSave:(NSString*)birth :(double)balance :(int)year;
- (BOOL*)XMLSave:(NSString*)birth :(double)balance :(int)year;
- (BOOL*)DBXML;

// the following methods are used for loading data
- (BOOL*)DBLoad:(UITextField*)birth :(UITextField*)balance :(UITextField*)year;
- (BOOL*)XMLLoad:(UITextField*)birth :(UITextField*)balance :(UITextField*)year;
@end
