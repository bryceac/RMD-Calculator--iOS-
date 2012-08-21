//
//  PrevYear.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 8/21/12.
//  Copyright 2012 Bryce Campbell. All rights reserved.
//

#import "PrevYear.h"

@implementation PrevYear

- (id) init
{
    if (self = [super init])
    {
        [self setIYear:nil];
    }
    
    return self;
}

+ (PrevYear*) prev
{
    PrevYear* newPrev = [[PrevYear alloc] init];
    return [newPrev autorelease];
}

- (void) setIYear:(NSString *)p
{
    iyear = [p intValue];
}

- (int) prevYear
{
    return iyear -1;
}

- (void) dealloc
{
    [self setIYear:nil];
    [super dealloc];
}
@end
