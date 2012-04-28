//
//  rmdSQL.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/21/12.
//  Copyright (c) 2012 Bryce Campbell. All rights reserved.
//

#import "rmdSQL.h"

@implementation rmdSQL
+(rmdSQL*) sql
{
    rmdSQL *newSQL = [[rmdSQL alloc] init];
    return [newSQL autorelease];
}

- (id) init
{
    if (self = [super init])
    {
        [self saveData:nil :0 :0];
        [self updateData:nil :0 :0];
        
        // set strings with no setter methods to zero or null
        birth = nil;
        bal = 0;
        year = 0;
        records = 0;
    }
    return self;
}

-(BOOL)saveData:(NSString *)a :(double)b :(int)c
{
    int test;
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
    if ([database executeUpdateWithFormat:@"INSERT INTO rmd (birth, bal, year) VALUES (%@, %f, %d)", a, b, c,nil]) 
    {
        test = 1;
    } else {
        test = 0;
    }
    [database close];
    
    if (test == 0) 
    {
        return NO;
    }
    return YES;
}

-(NSString*)birth
{
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT date(birth) FROM rmd LIMIT 1"];
    while ([results next]) 
    {
        birth = [results stringForColumnIndex:0];
    }
    [database close];
    return birth;
}
-(double)bal
{
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT bal FROM rmd LIMIT 1"];
    while ([results next]) 
    {
        bal = [results doubleForColumnIndex:0];
    }
    [database close];
    return bal;
}

-(int)year
{
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT year FROM rmd LIMIT 1"];
    while ([results next]) 
    {
        year = [results intForColumnIndex:0];
    }
    [database close];
    return year;
}

-(BOOL)records
{
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT count(*) FROM rmd"];
    while ([results next]) 
    {
        records = [results intForColumnIndex:0];
    }
    [database close];
    return records;
}
-(BOOL)updateData:(NSString *)d :(double)e :(int)f
{
    int test;
   
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
 if ([[self birth] isEqualToString:d] != YES && [self bal] != e && [self year] != f) {
    if ([database executeUpdateWithFormat:@"UPDATE rmd SET birth =%@, bal =%f, year =%d WHERE id = 1", d, e, f,nil]) 
    {
        test = 1;
    } else {
        test = 0;
    }
} else if ([[self birth] isEqualToString:d] != YES && [self bal] != e) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET birth =%@, bal =%f WHERE id = 1", d, e,nil]) 
        {
            test = 1;
        } else {
            test = 0;
        }
    } else if ([[self birth] isEqualToString:d] != YES && [self year] != f) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET birth =%@, year =%d WHERE id = 1", d, f,nil]) 
        {
            test = 1;
        } else {
            test = 0;
        }
    } else if ([self bal] != e && [self year] != f) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET bal =%f, year =%d WHERE id = 1", e, f,nil]) 
        {
            test = 1;
        } else {
            test = 0;
        }
        } else if ([[self birth] isEqualToString:d] != YES) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET birth =%@ WHERE id = 1", d,nil]) 
        {
            test = 1;
        } else {
            test = 0;
        }
    } else if ([self bal] != e) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET bal =%f WHERE id = 1", e,nil]) 
        {
            test = 1;
        } else {
            test = 0;
        }
    } else if ([self year] != f) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET year =%d WHERE id = 1", f,nil]) 
        {
            test = 1;
        } else {
            test = 0;
        }
    } else {
        test = 0;
    }
    [database close];
    
    if (test == 0) 
    {
        return NO;
    }
    return YES;
}

-(void) dealloc
{
    [self saveData:nil :0 :0];
    [self updateData:nil :0 :0];
    [super dealloc]; // free memory
}
@end
