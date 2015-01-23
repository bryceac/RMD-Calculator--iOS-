//
//  alert.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/20/15.
//
//

#import "alert.h"
#import "Data.h"
#define SaveDialog 1
#define LoadDialog 2

@implementation alert
@synthesize title, message, dialog, birth, born, balance, amount, year, era, answer;

- (id) initWithTitle:(NSString *)t message:(NSString *)m
{
    if (self = [super init])
    {
        self.title = t;
        self.message = m;
        self.birth = nil;
        self.balance = 0;
        self.year = 0;
        self.born = nil;
        self.amount = nil;
        self.era = nil;
        [self createMessageDialog:self.title message:self.message];
    }
    return self;
}

- (id) initSaveWithContent:(NSString *)t message:(NSString *)m :(NSString *)b :(double)a :(int)y
{
    if (self = [super init])
    {
        self.title = t;
        self.message = m;
        self.birth = b;
        self.balance = a;
        self.year = y;
        self.born = nil;
        self.amount = nil;
        self.era = nil;
        [self createSaveDialog:self.title :self.message :self.birth :self.balance :self.year];
    }
    return self;
}

- (id) initLoadWithContent:(NSString *)t message:(NSString *)m :(UITextField *)b :(UITextField *)a :(UITextField *)y
{
    if (self = [super init])
    {
        self.title = t;
        self.message = m;
        self.birth = nil;
        self.balance = 0;
        self.year = 0;
        self.born = b;
        self.amount = a;
        self.era = y;
        [self createLoadDialog:self.title :self.message :self.born :self.amount :self.era];
    }
    return self;
    
}

- (void)createMessageDialog:(NSString *)t message:(NSString *)m
{
        self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
}

- (void)createSaveDialog:(NSString *)t :(NSString *)m :(NSString *)b :(double)a :(int)y
{
    
    self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil] autorelease];
    self.dialog.tag = SaveDialog;
}

- (void)createLoadDialog:(NSString *)t :(NSString *)m :(UITextField *)birth :(UITextField *)balance :(UITextField *)year
{
    self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil] autorelease];
    self.dialog.tag = LoadDialog;
}

- (void)show
{
    [[self dialog] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = [alertView buttonTitleAtIndex:buttonIndex];
    Data *data = [[[Data alloc] init] autorelease];
    UIAlertView *status;
    
    // check type of dialog used and take appropiate actions
    if (alertView.tag == SaveDialog)
    {
        // if dialog is a save dialog, check user selection for whether or not they want xml
        if ([text isEqualToString:@"Yes"])
        {
            // try to create XML from app, before resorting to database
            if ([data XMLSave:self.birth :self.balance :self.year])
            {
                self.answer = true;
                /* status = [[[UIAlertView alloc] initWithTitle:@"XML Export Successful" message:@"Data from app was successfully saved to XML" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
            else if ([data DBXML]) {
                self.answer = true;
                /* status = [[[UIAlertView alloc] initWithTitle:@"Database XML Export Successful" message:@"Data was successfully saved to XML from the database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
            else
            {
                self.answer = false;
                /* status = [[[UIAlertView alloc] initWithTitle:@"XML Export Failed" message:@"Sorry, Data could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
        }
        else if ([text isEqualToString:@"No"])
        {
            if ([data DBSave:self.birth :self.balance :self.year])
            {
                self.answer = true;
                /* status = [[[UIAlertView alloc] initWithTitle:@"Data Saved Successfully" message:@"Data was successfully saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
            else
            {
                self.answer = false;
                /* status = [[[UIAlertView alloc] initWithTitle:@"Data Failed to Saved" message:@"Sorry, Data was unable to be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
        }
        else;
    }
    else if (alertView.tag == LoadDialog)
    {
        // if dialog is a load dialog, check whether user wants to import from XML
        if ([text isEqualToString:@"Yes"])
        {
            if ([data XMLLoad:self.born :self.amount :self.era])
            {
                // if XML was loaded successfully, attempt to save the data to the database too
                if ([data DBSave:self.born.text :self.amount.text.doubleValue :self.era.text.intValue])
                {
                    self.answer = true;
                    /* status = [[[UIAlertView alloc] initWithTitle:@"Data Imported Successfully" message:@"Data was successfully imported via XML and is saved in the database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [status show]; */
                }
                else
                {
                    self.answer = true;
                    /* status = [[[UIAlertView alloc] initWithTitle:@"Data Loaded Successfully" message:@"Data was loaded successfully, but you may need to save the data yourself." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [status show]; */
                }
            }
            else
            {
                self.answer = false;
                /* status = [[[UIAlertView alloc] initWithTitle:@"Data Failed to Load" message:@"Data could not be found because XML file either does not exist or cannot be read." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
        }
        else if ([text isEqualToString:@"No"])
        {
            if ([data DBLoad:self.born :self.amount :self.era])
            {
                self.answer = true;
                /* status = [[[UIAlertView alloc] initWithTitle:@"Data Loaded Successfully" message:@"Data was successfully loaded from database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
            else
            {
                self.answer = false;
                /* status = [[[UIAlertView alloc] initWithTitle:@"Data Failed to Load" message:@"Unable to load data from Database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show]; */
            }
        }
        else;
    }
    else;
}

- (void) dealloc
{
    self.title = nil;
    self.message = nil;
    self.dialog = nil;
    self.birth = nil;
    self.balance = 0;
    self.year = 0;
    self.born = nil;
    self.amount = nil;
    self.era = nil;
    [super dealloc];
}

@end
