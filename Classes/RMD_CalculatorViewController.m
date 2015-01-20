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
#import "apxml/APXML.h"

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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:brycecmpbell@gmail.com"]];
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

- (BOOL)save
{
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* sf = [[NSDateFormatter alloc] init];
    [sf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* mf = [[NSDateFormatter alloc] init];
    [mf setDateFormat:@"yyyy-MM-dd"];
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    
    NSNumber* number = [nf numberFromString:self.bal.text];
    NSString* born = self.birth.text;
    int distrib = self.year.text.intValue;
    double ira = number.doubleValue;
    
    NSDate* bdate = [sf dateFromString:born];
    [sf release];
    born = [mf stringFromDate:bdate];
    
    if ([db records] > 0)
    {
        if([db updateData:born :ira :distrib])
        {
            [mf release];
            [db release];
            [nf release];
            return true;
        } else {
            [mf release];
            [db release];
            [nf release];
            return false;
        }

    } else {
        if([db saveData:born :ira :distrib])
        {
            [mf release];
            [db release];
            [nf release];
            return true;
        } else {
            [mf release];
            [db release];
            [nf release];
            return false;
        }
    }
}

- (BOOL)load
{
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* bf = [[NSDateFormatter alloc] init];
    [bf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* bd;
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    
    if ([db records] > 0)
    {
        NSDate* birthdate = [df dateFromString:[db birth]];
        bd = [bf stringFromDate:birthdate];
        self.birth.text = bd;
        [bf release];
        [df release];
        self.bal.text = [nf stringFromNumber:[NSNumber numberWithDouble:[db bal]]];
        [nf release];
        self.year.text = [NSString stringWithFormat:@"%d", [db year]];
        self.status.text = @"All data loaded successfully";
    } else {
        self.status.text = @"Could not load data because no records exist.";
        [bf release];
        [df release];
        [nf release];
    }
    return false;
}

// the savedata method sends input to SQLite for insertion or updating, if record exists
- (IBAction)saveData:(id)sender
{
    alert *question = [[alert alloc] initWithTitle:@"Export to XML?" message:@"Do you want to save this as XML?" andType:true];
    
    [question show];
    
    if (question.answer)
    {
        if ([self exportXML])
        {
            self.status.text = @"Data exported to XML successfully.";
        }
    }
    if ([self save])
    {
        self.status.text = @"Data was saved successfully";
    }
    else
    {
        self.status.text = @"Data could not be saved";
    }
}

// the loadData method retrieves data from SQLite database
- (IBAction)loadData
{
    alert *question = [[alert alloc] initWithTitle:@"Import from XML?" message:@"Do you have an XML you want to import?" andType:true];
    
    [question show];
    
    if (question.answer)
    {
        if ([self importXML])
        {
            self.status.text = @"XML import was successful.";
        }
    }
    else
    {
        if ([self load])
        {
            self.status.text = @"Data loaded successfully";
        }
        else
        {
            self.status.text = @"Data failed to load";
        }
}

- (BOOL)exportXML
{
    // create variables needed to access documents directory and file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/rmd.xml", documentsDirectory];
    
    // create object to access sqlite and variables to parse data
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* bf = [[NSDateFormatter alloc] init];
    [bf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    
    // create dialog for user interaction
    alert *question = [[alert alloc] initWithTitle:@"Export from Database?" message:@"Do you want to export from Database?" andType:true];
    
    // create variable to hold xml
    NSMutableString *xml = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<rmd>\r\n"];
    
    [question show]; // ask user where to get data from
    
    // check how user wanted to retrieve data and perform export
    if (question.answer)
    {
        // make sure records exist in sqlite, otherwise pull from fields
        if (db.records > 0)
        {
            [xml appendString:[NSString stringWithFormat:@"<birth>%@</birth>\r\n", [bf stringFromDate:[df dateFromString:db.birth]]]];
            [xml appendString:[NSString stringWithFormat:@"<balance>%@</balance>\r\n", [nf stringFromNumber:[NSNumber numberWithDouble:db.bal]]]];
            [xml appendString:[NSString stringWithFormat:@"<year>%d</year>\r\n", db.year]];
        }
        else
        {
            [xml appendString:[NSString stringWithFormat:@"<birth>%@</birth>\r\n", self.birth.text]];
            [xml appendString:[NSString stringWithFormat:@"<balance>%@</balance>\r\n", self.bal.text]];
            [xml appendString:[NSString stringWithFormat:@"<year>%@</year>\r\n", self.year.text]];
        }
        
        [xml appendString:@"</rmd"];
        
        [xml writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    else
    {
        [xml appendString:[NSString stringWithFormat:@"<birth>%@</birth>\r\n", self.birth.text]];
        [xml appendString:[NSString stringWithFormat:@"<balance>%@</balance>\r\n", self.bal.text]];
        [xml appendString:[NSString stringWithFormat:@"<year>%@</year>\r\n", self.year.text]];
        [xml appendString:@"</rmd>"];
        
        [xml writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    
    // check if file exists and return true if it does
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        [bf release];
        [df release];
        [nf release];
        [question release];
        return true;
    }
    
    [bf release];
    [df release];
    [nf release];
    [question release];
    return false;
}

- (BOOL)importXML
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/rmd.xml", documentsDirectory];
    
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* bf = [[NSDateFormatter alloc] init];
    [bf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    
    // check if file exists and import its contents
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        NSString *xml = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:NULL];
        APDocument *doc = [APDocument documentWithXMLString:xml];
        
        APElement *rootElement = [doc rootElement];
        
        NSArray *children = [rootElement childElements];
        
        for (APElement *child in children)
        {
            if ([child.name isEqualToString:@"birth"])
            {
                self.birth.text = child.value;
            }
            else if ([child.name isEqualToString:@"balance"])
            {
                self.bal.text = child.value;
            }
            else
            {
                self.year.text = child.value;
            }
        }
        
        alert *question = [[alert alloc] initWithTitle:@"Import to Database?" message:@"Do you want to save this to the Database?" andType:true];
        
        [question show];
        
        if (question.answer)
        {
            if ([self save])
            {
                [bf release];
                [df release];
                [nf release];
                return true;
            }
            else
            {
                [bf release];
                [df release];
                [nf release];
                [question release];
                return false;
            }
            
        }
        else
        {
            [bf release];
            [df release];
            [nf release];
            [question release];
            return true;
        }
    } else {
        [bf release];
        [df release];
        [nf release];
        return false;
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
