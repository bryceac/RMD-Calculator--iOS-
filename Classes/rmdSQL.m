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
        [self updateData:nil :0 :0];
        
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
                birth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
        } else;
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);        
    }
    return birth;
}
-(double)bal
{
    sqlite3_stmt *stmt;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
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
    return bal;
}

-(int)year
{
    sqlite3_stmt *stmt;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
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
    return year;
}

-(BOOL)records
{
    sqlite3_stmt *stmt;
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
    return NO;
}
-(BOOL)updateData:(NSString *)d :(double)e :(int)f
{
    int test;
    if (sqlite3_open([self dpath], &mrdDB) == SQLITE_OK) 
    {
        sqlite3_stmt *stmt;
        NSString* updateSQL;
        const char *update_stmt;
        
        if (![[self birth] isEqualToString:d]) 
        {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
        } else if ([self bal] != e) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET bal = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_double(stmt, 1, e);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
        } else if ([self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET year = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_int(stmt, 1, f);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
        } else if (![[self birth] isEqualToString:d] && [self bal] != e) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth = \"?\", bal = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(stmt, 2, e);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
        } else if (![[self birth] isEqualToString:d] && [self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth = \"?\", year = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(stmt, 2, f);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
        } else if ([self bal] != e && [self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET bal = \"?\", year = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_double(stmt, 1, e);
            sqlite3_bind_int(stmt, 2, f);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
        } else if (![[self birth] isEqualToString:d] && [self bal] != e && [self year] != f) {
            updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth = \"?\", bal = \"?\", year = \"?\" WHERE id = 1"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
            
            sqlite3_bind_text(stmt, 1, [d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(stmt, 2, e);
            sqlite3_bind_int(stmt, 3, f);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) 
            {
                test = 1;
            } else {
                test = 0;
            }
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

-(void) dealloc
{
    [self setDBPath:nil];
    [self setDPath:nil];
    [self saveData:nil :0 :0];
    [self updateData:nil :0 :0];
    [super dealloc]; // free memory
}
@end
