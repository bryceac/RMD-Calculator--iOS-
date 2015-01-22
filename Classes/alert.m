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
@synthesize title, message, dialog, birth, born, balance, amount, year, era;

- (id) initWithTitle:(NSString *)t message:(NSString *)m andType:(BOOL*)b
{
    if (self = [super init])
    {
        self.title = t;
        self.message = m;
        [self createMessageDialog:self.title message:self.message question:b];
    }
    return self;
}

- (void)createMessageDialog:(NSString *)t message:(NSString *)m question:(BOOL *)b
{
        self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
}

- (void)createSaveDialog:(NSString *)t :(NSString *)m :(NSString *)birth :(double)balance :(int)year
{
    self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    self.dialog.tag = SaveDialog;
}

- (void)createLoadDialog:(NSString *)t :(NSString *)m :(UITextField *)birth :(UITextField *)balance :(UITextField *)year
{
    self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
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
    
    if (alertView.tag == SaveDialog)
    {
        if ([text isEqualToString:@"Yes"])
        {
            if ([data DBXML]) {
                status = [[[UIAlertView alloc] initWithTitle:@"Database XML Export Successful" message:@"Data was successfully saved to XML from the database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
            else if ([data XMLSave:self.birth :self.balance :self.year])
            {
                status = [[[UIAlertView alloc] initWithTitle:@"XML Export Successful" message:@"Data from app was successfully saved to XML" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
            else
            {
                status = [[[UIAlertView alloc] initWithTitle:@"XML Export Failed" message:@"Sorry, Data could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
        }
        else if ([text isEqualToString:@"No"])
        {
            if ([data DBSave:self.birth :self.balance :self.year])
            {
                status = [[[UIAlertView alloc] initWithTitle:@"Data Saved Successfully" message:@"Data was successfully saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
            else
            {
                status = [[[UIAlertView alloc] initWithTitle:@"Data Failed to Saved" message:@"Sorry, Data was unable to be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
        }
        else;
    }
    else if (alertView.tag == LoadDialog)
    {
        if ([text isEqualToString:@"Yes"])
        {
            if ([data XMLLoad:self.born :self.amount :self.era])
            {
                if ([data DBSave:self.born.text :self.amount.text.doubleValue :self.era.text.intValue])
                {
                    status = [[[UIAlertView alloc] initWithTitle:@"Data Imported Successfully" message:@"Data was successfully imported via XML and is saved in the database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [status show];
                }
                else
                {
                    status = [[[UIAlertView alloc] initWithTitle:@"Data Loaded Successfully" message:@"Data was loaded successfully, but you may need to save the data yourself." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [status show];
                }
            }
            else
            {
                status = [[[UIAlertView alloc] initWithTitle:@"Data Failed to Load" message:@"Data could not be found because XML file either does not exist or cannot be read." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
        }
        else if ([text isEqualToString:@"No"])
        {
            if ([data DBLoad:self.born :self.amount :self.era])
            {
                status = [[[UIAlertView alloc] initWithTitle:@"Data Loaded Successfully" message:@"Data was successfully loaded from database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
            }
            else
            {
                status = [[[UIAlertView alloc] initWithTitle:@"Data Failed to Load" message:@"Unable to load data from Database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [status show];
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
    [super dealloc];
}

@end
