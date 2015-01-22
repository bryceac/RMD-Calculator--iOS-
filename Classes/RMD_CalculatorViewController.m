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
#import "PrevYear.h"
#import "alert.h"
#import "APXML.h"

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

/* the following hides the keyboard when the user says done */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:ios@brycecampbell.me"]];
    }
}

// display the year picker
- (IBAction)displayYear
{
    self.yt.hidden = NO;
    self.picker.hidden = NO;
}

// if year picker is visible, this sets the year with its selection
- (IBAction)setYear
{
    NSInteger row = [picker selectedRowInComponent:0];
	NSString* choice = [pickerArray objectAtIndex:row];
    self.year.text = choice;
    self.picker.hidden = YES;
    self.yt.hidden = YES;
    PrevYear* dYear = [[PrevYear alloc] init]; // create instance of PrevYear class
    [dYear setIYear:self.year.text]; // take year inputted as initial year
    self.bal.placeholder = [NSString stringWithFormat:@"Balance on 12/31/%d", [dYear prevYear]];
    [dYear release];
    
}

// display birth picker
- (IBAction)displayBirth
{
    self.dt.hidden = NO;
    self.dpicker.hidden = NO;
}

// set birth date from picker selection
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

// the calc METHOD sends input to RMD class for calculation and displays results in text field
- (IBAction)calc:(id)sender
{
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM/dd/yyyy"];
    // the following allows comma separators to be inputted
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    NSNumber* ira = [nf numberFromString:self.bal.text];
    
    // the following sends input to RMD class and returns results
	RMD* retire = [[RMD alloc] init];
	NSString* bd = self.birth.text;
    NSString* syear = self.year.text;
	double balance = ira.doubleValue;
	[retire setBD:[df dateFromString:bd]];
	[retire setBal:balance];
	[retire setYear:[syear intValue]];
	self.rmd.text = [nf stringFromNumber:[NSNumber numberWithDouble:[retire rmd]]];
    // release formatters
	[df release];
    [nf release];
	[retire release]; // release RMD class from memory
}

// the savedata method displays alert view that handles saving data
- (IBAction)saveData:(id)sender
{
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    
    // display dialog asking how to save data. Values are passed, so that XML can still be created if a database cannot be used
    alert *question = [[[alert alloc] initSaveWithContent:@"Save As XML?" message:@"Do you want to export data to XML?" :self.birth.text :[nf numberFromString:self.bal.text].doubleValue :self.year.text.intValue] autorelease];
    
    [question show];
    [nf release];
}

// the loadData method displays alert view that will handle loading data.
- (IBAction)loadData
{
    // display dialog asking if user wants to load data from XML. UITextfield objects are passed, in order to populate view
    alert *question = [[[alert alloc] initLoadWithContent:@"Load from XML?" message:@"Do you want to import data from XML?" :self.birth :self.bal :self.year] autorelease];
    
    [question show];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSArray* array = [[NSArray alloc] initWithObjects:@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",nil];
	NSDate* now = [NSDate date];
    [dpicker setDate:now];
    self.pickerArray = array;
    self.yt.hidden = YES;
    self.picker.hidden = YES;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.dt.hidden = YES;
    self.dpicker.hidden = YES;
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
