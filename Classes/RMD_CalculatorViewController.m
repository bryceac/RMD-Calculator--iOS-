//
//  RMD_CalculatorViewController.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/25/11.
//  Copyright 2011 Bryce Campbell. All rights reserved.
//

#import "RMD_CalculatorViewController.h"
#import "RMD.h"
#import "rmdSQL.h"

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
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* sf = [[NSDateFormatter alloc] init];
    [sf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* mf = [[NSDateFormatter alloc] init];
    [mf setDateFormat:@"yyyy-MM-dd"];
    
    NSString* born = self.birth.text;
    int distrib = self.year.text.intValue;
    double ira = self.bal.text.doubleValue;
    
    NSDate* bdate = [sf dateFromString:born];
    [sf release];
    born = [mf stringFromDate:bdate];
    
    // set the database path
    [db setDBPath:@"mrd.db"];
    [db setDPath:[db dbpath]];
    if([db saveData:born :ira :distrib])
    {
        self.status.text = @"Save successful";
    } else {
        self.status.text = @"Could not save data";
    }
    [mf release];
    [db release];
}

- (IBAction)updateData:(id)sender
{
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* sf = [[NSDateFormatter alloc] init];
    [sf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* mf = [[NSDateFormatter alloc] init];
    [mf setDateFormat:@"yyyy-MM-dd"];
    
    NSString* born = self.birth.text;
    int distrib = self.year.text.intValue;
    double ira = self.bal.text.doubleValue;
    
    NSDate* bdate = [sf dateFromString:born];
    [sf release];
    born = [mf stringFromDate:bdate];
    
    // set the database path
    [db setDBPath:@"mrd.db"];
    [db setDPath:[db dbpath]];
    if ([db records])
    {
        if([db updateData:born :ira :distrib])
        {
            self.status.text = @"Record updated sucessfully";
        } else {
            self.status.text = @"Record could not be updated";
        }
    } else {
        self.status.text = @"Cannot find any records";
    }
    
    [mf release];
    [db release];
}

- (IBAction)loadData
{
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* bf = [[NSDateFormatter alloc] init];
    [bf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* bd;
    
    // set the database path
    [db setDBPath:@"mrd.db"];
    [db setDPath:[db dbpath]];
    
    if ([db records] > 0) 
    {
        NSDate* birthdate = [df dateFromString:[db birth]];
        bd = [bf stringFromDate:birthdate];
        self.birth.text = bd;
        [bf release];
        [df release];
        self.bal.text = [NSString stringWithFormat:@"%.2f", [db bal]];
        self.year.text = [NSString stringWithFormat:@"%d", [db year]];
        self.status.text = @"All data loaded successfully";
    } else {
        self.status.text = @"Could not load data because no records exist.";
        [bf release];
        [df release];
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
