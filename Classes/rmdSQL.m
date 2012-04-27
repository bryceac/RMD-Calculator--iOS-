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
    /* if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
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
    return YES; */
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
    /* if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        sqlite3_stmt *stmt;
        NSString* birth_sql = [NSString stringWithFormat:@"SELECT date(birth) FROM rmd LIMIT 1"];
        const char* birth_stmt = [birth_sql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, birth_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if ((char *)sqlite3_column_text(stmt, 0))
            {
                birth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
        } else;
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);        
    }
    return birth; */
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
    /* if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* ysql = [NSString stringWithFormat:@"SELECT bal FROM rmd LIMIT 1"];
        const char* y_stmt = [ysql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, y_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if (sqlite3_column_double(stmt, 0))
            {
                bal = sqlite3_column_double(stmt, 0);
            }
        } else;
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    return bal; */
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
    /* if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* ysql = [NSString stringWithFormat:@"SELECT year FROM rmd LIMIT 1"];
        const char* y_stmt = [ysql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, y_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            if (sqlite3_column_int(stmt, 0))
            {
                year = sqlite3_column_int(stmt, 0);
            }
        } else;
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    return year; */
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
    /* sqlite3_stmt *stmt;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        NSString* rsql = [NSString stringWithFormat:@"SELECT  COUNT(*) rmd"];
        const char* r_stmt = [rsql UTF8String];
        
        sqlite3_prepare_v2(mrdDB, r_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            records = sqlite3_column_int(stmt, 0);
            return records;
        } else;
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
        
    }
    return NO; */
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
   /* if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        sqlite3_stmt *stmt;
        NSString* updateSQL;
        const char *update_stmt;
        
        if ([[self birth] isEqualToString:d] != YES) 
        {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
        } else if ([self bal] != e) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET bal =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_double(stmt, 1, e);
        } else if ([self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET year =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_int(stmt, 1, f);
        } else if ([[self birth] isEqualToString:d] != YES && [self bal] != e) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth =?, bal =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(stmt, 2, e);
        } else if ([[self birth] isEqualToString:d] != YES && [self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth =?, year =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(stmt, 2, f);
        } else if ([self bal] != e && [self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET bal =?, year =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_double(stmt, 1, e);
            sqlite3_bind_int(stmt, 2, f);
        } else if ([[self birth] isEqualToString:d] != YES && [self bal] != e && [self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth =?, bal =?, year =? WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(stmt, 2, e);
            sqlite3_bind_int(stmt, 3, f);
        } else;
        
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
    return YES; */
    FMDatabase *database = [FMDatabase databaseWithPath:[DBPath getDBPath]];
    [database open];
    if ([[self birth] isEqualToString:d] != YES)
    {
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
    } else if ([[self birth] isEqualToString:d] != YES && [self bal] != e && [self year] != f) {
        if ([database executeUpdateWithFormat:@"UPDATE rmd SET birth =%@, bal =%f, year =%d WHERE id = 1", d, e, f,nil]) 
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
