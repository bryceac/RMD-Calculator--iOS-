//
//  alert.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/20/15.
//
//

#import "alert.h"

@implementation alert
@synthesize title, message, answer, dialog;

- (id) initWithTitle:(NSString *)t message:(NSString *)m andType:(BOOL*)b
{
    if (self = [super init])
    {
        self.title = t;
        self.message = m;
        [self createDialog:self.title message:self.message question:b];
        self.answer = nil;
    }
    return self;
}

- (void)createDialog:(NSString *)t message:(NSString *)m question:(BOOL *)b
{
    if (b == false)
    {
        self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    }
    else
    {
        self.dialog = [[[UIAlertView alloc] initWithTitle:t message:m delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil] autorelease];
    }
}

- (void)show
{
    [[self dialog] show];
    
    // loop to delay code execution, so user can give input.
    while (self.dialog.hidden == NO && self.dialog.superview != nil)
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([text isEqualToString:@"Yes"])
    {
        self.answer = true;
    }
    else if ([text isEqualToString:@"No"])
    {
        self.answer = false;
    }
}

- (void) dealloc
{
    self.title = nil;
    self.message = nil;
    self.answer = nil;
    [super dealloc];
}

@end
