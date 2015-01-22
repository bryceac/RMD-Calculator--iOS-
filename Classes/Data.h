//
//  Data.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/21/15.
//
//

// the Data class is used to interact with outside classes
#import <Foundation/Foundation.h>

@interface Data : NSObject
- (BOOL*)saveXML:(NSString*)birth :(double)balance :(int)year;
- (BOOL*)dbXML:(NSString*)birth :(double)balance :(int)year;
- (BOOL*)dbLoad:(UITextField*)birth :(UITextField*)balance :(UITextField*)year;
- (BOOL*)loadXML:(UITextField*)birth :(UITextField*)balance :(UITextField*)year;

@end
