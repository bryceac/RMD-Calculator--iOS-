//
//  Data.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/21/15.
//
//

// the follow class is used to transmit data from view controller to new class
#import "Data.h"
#import "rmdSQL.h"

@implementation Data
- (BOOL*)saveXML:(NSString*)birth :(double)balance :(int)year
{
    
}
- (BOOL*)saveDB:(NSString*)birth :(double)balance :(int)year
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

- (BOOL*)dbLoad:(UITextField*)birth :(UITextField*)balance :(UITextField*)year
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
        return true;
    } else {
        [bf release];
        [df release];
        [nf release];
    }
    return false;
}
- (BOOL*)loadXML:(UITextField*)birth :(UITextField*)balance :(UITextField*)year
{
    
}
@end
