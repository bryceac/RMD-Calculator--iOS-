//
//  RMD_CalculatorViewController.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/25/11.
//  Copyright 2011 Bryce Campbell. All rights reserved.
//

#import "RMD_CalculatorViewController.h"
#import "RMD.h"

@implementation RMD_CalculatorViewController
@synthesize picker;
@synthesize pickerArray;
@synthesize birth;
@synthesize bal;
@synthesize rmd;
@synthesize year;
@synthesize yt;
@synthesize dt;
@synthesize dpicker;
@synthesize status;

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)displayYear
{
    self.yt.hidden = NO;
    self.picker.hidden = NO;
}

- (IBAction)setYear
{
    NSInteger row = [picker selectedRowInComponent:0];
	NSString* choice = [pickerArray objectAtIndex:row];
    self.year.text = choice;
    self.picker.hidden = YES;
    self.yt.hidden = YES;
    
}

- (IBAction)displayBirth
{
    self.dt.hidden = NO;
    self.dpicker.hidden = NO;
}

- (IBAction)setB
{
    NSDateFormatter* sf = [[NSDateFormatter alloc] init];
    [sf setDateFormat:@"MM/dd/yyyy"];
    NSDate* selected = [dpicker date];
    NSString* date = [sf stringFromDate:selected];
    self.birth.text = date;
    self.dpicker.hidden = YES;
    self.dt.hidden = YES;
    [sf release];
}

- (IBAction)calc:(id)sender
{
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM/dd/yyyy"];
	RMD* retire = [[RMD alloc] init];
	NSString* bd = self.birth.text;
    NSString* syear = self.year.text;
	double balance = self.bal.text.doubleValue;
	[retire setBD:[df dateFromString:bd]];
	[retire setBal:balance];
	[retire setYear:[syear intValue]];
	self.rmd.text = [NSString stringWithFormat:@"%.2f", [retire rmd]];
	[df release];
	[retire release];
}

- (IBAction)saveData:(id)sender
{
    NSDateFormatter* sf = [[NSDateFormatter alloc] init];
    [sf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* mf = [[NSDateFormatter alloc] init];
    [mf setDateFormat:@"yyyy-MM-dd"];
    sqlite3_stmt *statement;
    
    NSString* born = self.birth.text;
    int distrib = self.year.text.intValue;
    double ira = self.bal.text.doubleValue;
    
    NSDate* bdate = [sf dateFromString:born];
    [sf release];
    born = [mf stringFromDate:bdate];
    
    if ([self checkRecords] == 0)
    {
        // get document directory
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
    
        // build path to database
        dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"mrd.db"]];
    
        const char *dpath = [dbpath UTF8String];
        if (sqlite3_open(dpath, &mrdDB) == SQLITE_OK) 
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO rmd (birth, bal, year) VALUES (?, ?, ?)"];
            const char *insert_stmt = [insertSQL UTF8String];
        
            sqlite3_prepare_v2(mrdDB, insert_stmt, -1, &statement, NULL);
        
            sqlite3_bind_text(statement, 1, [born UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(statement, 2, ira);
            sqlite3_bind_int(statement, 3, distrib);
        
            if (sqlite3_step(statement) == SQLITE_DONE) 
            {
                self.status.text = @"Data saved successfully";
            } else {
                self.status.text = @"Data was not saved";
            }
        
            sqlite3_finalize(statement);
            sqlite3_close(mrdDB);
        }
    } else if ([self checkRecords] == 1 && ![[self getSQLBirth] isEqualToString:born] && [[self getSQLBirth] length] != 0) 
    {
        [self updateBirth:born :[self getSQLBirth]];
    } else {
        self.status.text = @"There is Nothing to save or update";
    }
    [mf release];
}

- (NSString*)getSQLBirth
{
    sqlite3_stmt *stmt;
    NSString *old, *bd;
    // get document directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // build path to database
    dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"mrd.db"]];
    
    const char *dpath = [dbpath UTF8String];
    if (sqlite3_open(dpath, &mrdDB)) 
    {
        NSString* bdSQL = [NSString stringWithFormat:@"SELECT date(birth) FROM rmd LIMIT 1"];
        const char *bd_stmt = [bdSQL UTF8String];
        
        sqlite3_prepare_v2(mrdDB, bd_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_ROW) 
        {
            bd = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    
    old = bd;
    [bd release];
    return old;
}

- (int)checkRecords
{
    sqlite3_stmt *stmt;
    // get document directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    int records;
    
    // build path to database
    dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"mrd.db"]];
    
    const char *dpath = [dbpath UTF8String];
    if (sqlite3_open(dpath, &mrdDB) == SQLITE_OK) 
    {
        NSString* count;
        NSString* recordSQL = [NSString stringWithFormat:@"SELECT count(*) FROM rmd"];
        const char* count_query = [recordSQL UTF8String];
        
        sqlite3_prepare_v2(mrdDB, count_query, -1, &stmt, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) 
        {
            count = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            records = count.intValue;
            [count release];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
    return records;
}

- (void)updateBirth:(NSString *)b:(NSString*)c
{
    sqlite3_stmt *stmt;
    // get document directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // build path to database
    dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"mrd.db"]];
    
    const char *dpath = [dbpath UTF8String];
    if (sqlite3_open(dpath, &mrdDB) == SQLITE_OK) 
    {
        NSString* updateSQL = [NSString stringWithFormat:@"UPDATE rmd SET birth = \"?\" WHERE birth = ?"];
        const char *update_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(mrdDB, update_stmt, -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [b UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [c UTF8String], -1, NULL);
        if (sqlite3_step(stmt) == SQLITE_OK) 
        {
            self.status.text = @"Successfully updated birth date field";
        } else;
        sqlite3_finalize(stmt);
        sqlite3_close(mrdDB);
    }
}

- (IBAction)loadData
{
    NSDateFormatter* bf = [[NSDateFormatter alloc] init];
    [bf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* balance;
    NSString* dyear;
    
    sqlite3_stmt *stmt;
    
    // get document directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // build path to database
    dbpath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"mrd.db"]];
    
    const char *dpath = [dbpath UTF8String];
    
    if (sqlite3_open(dpath, &mrdDB) == SQLITE_OK) 
    {
        NSString* query = [NSString stringWithFormat:@"SELECT date(birth), bal, year FROM rmd LIMIT 1"];
        const char* query_statement = [query UTF8String];
        
        if (sqlite3_prepare_v2(mrdDB, query_statement, -1, &stmt, NULL) == SQLITE_OK) 
        {
            if (sqlite3_step(stmt) == SQLITE_ROW) 
            {
                if ((char *)sqlite3_column_text(stmt, 0))
                {
                    NSDate* sdate;
                    NSString* birthDate;
                    
                    birthDate = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                    sdate = [df dateFromString:birthDate];
                    self.birth.text = [bf stringFromDate:sdate];
                    [birthDate release];
                }
                balance = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                dyear = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                
                self.bal.text = balance;
                [balance release];
                
                self.year.text = dyear;
                [dyear release];
                
                self.status.text = @"data loaded sucessfully";
                [bf release];
                [df release];
            } else {
                self.status.text = @"Cannot find/retrieve saved data";
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(mrdDB);
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	NSArray* array = [[NSArray alloc] initWithObjects:@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",nil];
	NSDate* now = [NSDate date];
    [dpicker setDate:now];
    self.pickerArray = array;
    self.yt.hidden = YES;
    self.picker.hidden = YES;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.dt.hidden = YES;
    self.dpicker.hidden = YES;
    self.status.text = nil;
	[array release];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerArray objectAtIndex:row];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
