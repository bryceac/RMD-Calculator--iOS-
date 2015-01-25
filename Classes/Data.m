//
//  Data.m
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/22/15.
//
//

#import "Data.h"
#import "rmdSQL.h"
#import "APXML.h"

@implementation Data

// the DBSave method saves data to database
- (BOOL*)DBSave:(NSString*)birth :(double)balance :(int)year
{
    rmdSQL* db = [[rmdSQL alloc] init];
    NSDateFormatter* sf = [[NSDateFormatter alloc] init];
    [sf setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter* mf = [[NSDateFormatter alloc] init];
    [mf setDateFormat:@"yyyy-MM-dd"];
    
    NSString* born = birth;
    
    NSDate* bdate = [sf dateFromString:born];
    [sf release];
    born = [mf stringFromDate:bdate];
    
    if ([db records] > 0)
    {
        if([db updateData:born :balance :year])
        {
            [mf release];
            [db release];
            return true;
        } else {
            [mf release];
            [db release];
            return false;
        }
        
    } else {
        if([db saveData:born :balance :year])
        {
            [mf release];
            [db release];
            return true;
        } else {
            [mf release];
            [db release];
            return false;
        }
    }
}

// the XML save method saves data to XML
- (BOOL*)XMLSave:(NSString*)birth :(double)balance :(int)year
{
    // create variables needed to access documents directory and file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/rmd.xml", documentsDirectory];
    
    // create object to access sqlite and variables to parse data
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setPositiveFormat:@"#,###.##"];
    [nf setNegativeFormat:@"#,###.##"];
    
    // create variable to hold xml
    NSMutableString *xml = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<rmd>\r\n"];
    
    [xml appendString:[NSString stringWithFormat:@"<birth>%@</birth>\r\n", birth]];
    [xml appendString:[NSString stringWithFormat:@"<balance>%@</balance>\r\n", [nf stringFromNumber:[NSNumber numberWithDouble:balance]]]];
    [xml appendString:[NSString stringWithFormat:@"<year>%d</year>\r\n", year]];
        
    [xml appendString:@"</rmd"];
        
    [xml writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    // check if file exists and return true if it does
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        [nf release];
        return true;
    }
    else
    {
        [nf release];
        return false;
    }
}

// the DBXML method saves database from a database to XML
- (BOOL*)DBXML
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
    
    // create variable to hold xml
    NSMutableString *xml = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<rmd>\r\n"];
    
    // make sure records exist in sqlite, otherwise pull from fields
    if (db.records > 0)
    {
        [xml appendString:[NSString stringWithFormat:@"<birth>%@</birth>\r\n", [bf stringFromDate:[df dateFromString:db.birth]]]];
        [xml appendString:[NSString stringWithFormat:@"<balance>%@</balance>\r\n", [nf stringFromNumber:[NSNumber numberWithDouble:db.bal]]]];
        [xml appendString:[NSString stringWithFormat:@"<year>%d</year>\r\n", db.year]];
        
        [xml appendString:@"</rmd"];
        
        [xml writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    else
    {
        [bf release];
        [df release];
        [nf release];
        return false;
    }
    
    // check if file exists and return true if it does
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
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
        return false;
    }
}

// the DBLoad method loads data from a database
- (BOOL*)DBLoad:(UITextField*)birth :(UITextField*)balance :(UITextField*)year
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
        birth.text = bd;
        [bf release];
        [df release];
        balance.text = [nf stringFromNumber:[NSNumber numberWithDouble:[db bal]]];
        [nf release];
        year.text = [NSString stringWithFormat:@"%d", [db year]];
        return true;
    } else {
        [bf release];
        [df release];
        [nf release];
        return false;
    }
}

// the XMLLoad method loads data from XML file
- (BOOL*)XMLLoad:(UITextField*)birth :(UITextField*)balance :(UITextField*)year
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/rmd.xml", documentsDirectory];
    
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
                birth.text = child.value;
            }
            else if ([child.name isEqualToString:@"balance"])
            {
                balance.text = child.value;
            }
            else
            {
                year.text = child.value;
            }
        }
        return true;
    }
    return false;
}
@end
