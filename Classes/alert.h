//
//  alert.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 1/20/15.
//
//

#import <Foundation/Foundation.h>

@interface alert : NSObject <UIAlertViewDelegate>
{
    NSString *title, *message;
    UIAlertView *alert;
}

// set up properties, in order to assign variables easily
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;

// create methods needed for class
- (void)createDialog:(NSString*)t message:(NSString*)m question:(BOOL*)b; // method to create dialog
- (void)show; // method to show dialog

- (id) initWithTitle:(NSString*)t message:(NSString *)m andType:(Bool*)b; // initializer to quickly create dialogs
@end
