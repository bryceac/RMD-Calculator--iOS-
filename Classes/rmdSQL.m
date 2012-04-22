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
        [self setDBPath:nil];
        [self setDPath:nil];
        [self saveData:nil :0 :0];
        [self updateBal:0];
        [self updateBirth:nil];
        [self updateYear:0];
        
        // set strings with no setter methods to zero or null
        birth = nil;
        bal = 0;
        year = 0;
        records = 0;
    }
    return self;
}

-(void)setDBPath:(NSString *)f
{
    // get document directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // build database path
    dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:f]];
}

-(void)setDPath:(NSString *)g
{
    dpath = [g UTF8String];
}

-(NSString*)dbpath
{
    return dbpath;
}

-(const char*)dpath
{
    return dpath;
}

-(BOOL)saveData:(NSString *)a :(double)b :(int)c
{
    int test;
    
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        sqlite3_stmt *stmt;
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO rmd (birth, bal, year) VALUES (?, ?, ?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(mrdDB, insert_stmt, -1, &stmt, NULL);
        
        sqlite3_bind_text(stmt, 1, [a UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(stmt, 2, b);
        sqlite3_bind_int(stmt, 3, c);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) 
        {
            test = 1;
        } else {
            test = 0;
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    
    if (test == 0) 
    {
        return NO;
    }
    return YES;
}

-(NSString*)birth
{
    NSString *curr;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        sqlite3_stmt *stmt;
        NSString* birth_sql = [NSString stringWithFormat:@"SELECT date(birth) FROM rmd LIMIT 1"];
        const char* birth_stmt = [birth_sql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, birth_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if ((char *)sqlite3_column_text(stmt, 0))
            {
                NSString* result = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                curr = result;
                [result release];
            }
        } else {
            NSLog(@"Either no record can be found or field is empty");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    birth = curr;
    return birth;
}
-(double)bal
{
    sqlite3_stmt *stmt;
    NSString *curr;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* balSQL = [NSString stringWithFormat:@"SELECT bal FROM rmd LIMIT 1"];
        const char* bal_stmt = [balSQL UTF8String];
        
        sqlite3_prepare_v2(mrdDB, bal_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if ((char *)sqlite3_column_text(stmt, 0))
            {
                NSString* result = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                curr = result;
                [result release];
            }
        } else {
            NSLog(@"Either no record can be found or field is empty");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    bal = curr.doubleValue;
    return bal;
}

-(int)year
{
    sqlite3_stmt *stmt;
    NSString *curr;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* ysql = [NSString stringWithFormat:@"SELECT year FROM rmd LIMIT 1"];
        const char* y_stmt = [ysql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, y_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if ((char *)sqlite3_column_text(stmt, 0))
            {
                NSString* result = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                curr = result;
                [result release];
            }
        } else {
            NSLog(@"Either no record can be found or field is empty");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    year = curr.intValue;
    return year;
}

-(int)records
{
    sqlite3_stmt *stmt;
    NSString *curr;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* rsql = [NSString stringWithFormat:@"SELECT  COUNT(*) rmd"];
        const char* r_stmt = [rsql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, r_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            NSString* result = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            curr = result;
            [result release];
        } else {
            NSLog(@"No records exist");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    records = curr.intValue;
    return records;
}

-(void)updateBirth:(NSString *)m
{
    nbirth = m;
}

-(void)updateBal:(double)n
{
    nbal = n;
}

-(void)updateYear:(int)o
{
    nyear = o;
}

-(NSString*)nbirth
{
    return nbirth;
}

-(double)nbal
{
    return nbal;
}

-(int)nyear
{
    return nyear;
}

-(void) dealloc
{
    [self setDBPath:nil];
    [self setDPath:nil];
    [self saveData:nil :0 :0];
    [self updateBal:0];
    [self updateBirth:nil];
    [self updateYear:0];
    [super dealloc]; // free memory
}
@end
