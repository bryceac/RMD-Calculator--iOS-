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

// the savedata method saves user input to either an XML file or the database at user's choice
- (IBAction)saveData:(id)sender
{
    alert *status;
    alert *question = [[[alert alloc] initWithTitle:@"Export to XML?" message:@"Do you want to save this as XML?" andType:true] autorelease];
    
    [question show];
    
    if (question.answer)
    {
        if ([self exportXML])
        {
            status = [[[alert alloc] initWithTitle:@"XML Export Successful" message:@"Data exported to XML successfully." andType:false] autorelease];
            
            [status show];
            // self.status.text = @"Data exported to XML successfully.";
        }
        else
        {
            status = [[[alert alloc] initWithTitle:@"XML Export Failed" message:@"Unable to export XML." andType:false] autorelease];
            
            [status show];
        }
    }
    else
    {
        if ([self save])
        {
        status = [[[alert alloc] initWithTitle:@"Record Saved Successfully" message:@"Data was saved to database successfully." andType:false] autorelease];
        
        [status show];
        // self.status.text = @"Data was saved successfully";
        }
        else
        {
            status = [[[alert alloc] initWithTitle:@"Failed to Save Data" message:@"Data could not be saved" andType:false] autorelease];
            
            [status show];
        }
    }
}

// the loadData method retrieves database from xml or database according to user's choice
- (IBAction)loadData
{
    alert *status;
    alert *question = [[[alert alloc] initWithTitle:@"Import from XML?" message:@"Do you have an XML you want to import?" andType:true] autorelease];
    
    [question show];
    
    // check user input and perform code based on it
    if (question.answer)
    {
        if ([self importXML])
        {
            status = [[[alert alloc] initWithTitle:@"XML Import Successful" message:@"Data successfully retrieved from XML." andType:false] autorelease];
            
            [status show];
            // self.status.text = @"XML import was successful.";
        }
        else
        {
            status = [[[alert alloc] initWithTitle:@"XML Import Failed" message:@"Unable to import from XML." andType:false] autorelease];
            
            [status show];
        }
    }
    else
    {
        if ([self load])
        {
            status = [[[alert alloc] initWithTitle:@"Database Import Successful" message:@"Data loaded sucessfully." andType:false] autorelease];
            
            [status show];
            // self.status.text = @"Data loaded successfully";
        }
        else
        {
            status = [[[alert alloc] initWithTitle:@"Database Import Failed" message:@"Unable to load from database." andType:false] autorelease];
            
            [status show];
            // self.status.text = @"Data failed to load";
        }
    }
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
