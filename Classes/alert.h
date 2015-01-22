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
    NSString *title, *message, *birth;
    int year;
    double balance;
    UIAlertView *dialog;
    UITextField *born, *amount, *era;
}

// set up properties, in order to assign variables easily
@property (nonatomic, retain) NSString *title, *message, *birth;
@property (assign) int year;
@property (assign) double balance;
@property (nonatomic, retain) UITextField *born, *amount, *era;
@property (nonatomic, assign) UIAlertView *dialog;

// create methods needed for class
- (void)createMessageDialog:(NSString*)t message:(NSString*)m; // method to create message dialog
- (void)createSaveDialog:(NSString*)t :(NSString*)m :(NSString*)birth :(double)balance :(int)year; // method to create save dialog
- (void)createLoadDialog:(NSString*)t :(NSString*)m :(UITextField*)birth :(UITextField*)balance :(UITextField*)year; // message to create load dialog
- (void)show; // method to show dialog

// initialization methods
- (id) initWithTitle:(NSString*)t message:(NSString *)m; // initializer to quickly create message dialogs
- (id) initLoadWithContent:(NSString*)t message:(NSString *)m :(UITextField*)birth :(UITextField*)balance :(UITextField*)year;
- (id) initSaveWithContent:(NSString*)t message:(NSString *)m :(NSString*)birth :(double)balance :(int)year;

@end
