//
//  alert.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/20/15.
//
//

#import "alert.h"

@implementation alert
@synthesize title, message;

- (id) initWithTitle:(NSString *)t message:(NSString *)m andType:(id)b
{
    if (self = [super init])
    {
        self.title = t;
        self.message = m;
    }
    return self;
}

- (void)createDialog:(NSString *)t message:(NSString *)m question:(BOOL *)b
{
    
}

- (void)show
{
    
}

@end
