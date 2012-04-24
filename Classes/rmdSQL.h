//
//  rmdSQL.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/21/12.
//  Copyright (c) 2012 Bryce Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface rmdSQL : NSObject
{
    NSString* dbpath;
    sqlite3 *mrdDB;
    NSString *birth;
    int records, year;
    double bal;
    
    // variables to get document directory
    NSArray *dirPaths;
    NSString *docsDir;
    
    const char* dpath;    
}

+(rmdSQL*) sql;
/* the following are setter methods or methods to perform SQL operations like UPDATE and INSERT */
-(void)setDBPath:(NSString*)f;
-(void)setDPath:(NSString*)g;
-(BOOL)saveData:(NSString*)a:(double)b:(int)c;
-(BOOL)updateData:(NSString*)d:(double)e:(int)f;
/* the following three are used to retrieve the currently saved data for input to programs */
-(NSString*)birth;
-(double)bal;
-(int)year;
-(BOOL)records; // method used to determine whether update is possible or not
// the following gets the database path
-(const char*)dpath;
-(NSString*)dbpath;
@end
