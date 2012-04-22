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
        [self saveData:nil :nil :nil];
        [self updateBal:nil];
        [self updateBirth:nil];
        [self updateYear:0];
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

-(void)saveData:(NSString *)a :(double)b :(int)c
{
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO rmd (birth, bal, year) VALUES (?, ?, ?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(mrdDB, insert_stmt, -1, &stmt, NULL);
        
        sqlite3_bind_text(stmt, 1, [a UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(stmt, 2, b);
        sqlite3_bind_int(stmt, 3, c);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) 
        {
            NSLog(@"Save successful");
        } else {
            NSLog(@"Could not save date");
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
}

-(NSString*)birth
{
    NSString *curr;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* birth_sql = [NSString stringWithFormat:@"SELECT date(birth) FROM rmd LIMIT 1"];
        const char* birth_stmt = [birth_sql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, birth_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if ((char *)sqlite3_column_text(stmt, 0))
            {
                curr = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_int(stmt, 0)];
            }
        } else {
            NSLog(@"Either no record can be found or field is empty");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    birth = curr;
    [curr release];
    return birth;
}
-(double)bal
{
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
                curr = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_int(stmt, 0)];
            }
        } else {
            NSLog(@"Either no record can be found or field is empty");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    bal = curr.doubleValue;
    [curr release];
    return bal;
}

-(int)year
{
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
                curr = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_int(stmt, 0)];
            }
        } else {
            NSLog(@"Either no record can be found or field is empty");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    year = curr.intValue;
    [curr release];
    return year;
}

-(int)records
{
    NSString *curr;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* rsql = [NSString stringWithFormat:@"SELECT  COUNT(*) rmd"];
        const char* r_stmt = [rsql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, r_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            curr = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_int(stmt, 0)];
        } else {
            NSLog(@"No records exist");
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    records = curr.intValue;
    [curr release];
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
    [self saveData:nil :nil :nil];
    [self updateBal:nil];
    [self updateBirth:nil];
    [self updateYear:0];
    [super dealloc]; // free memory
}
@end
