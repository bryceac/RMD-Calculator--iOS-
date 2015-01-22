//
//  RMD_CalculatorViewController.h
//  RMD Calculator
//
//  Created by Bryce Campbell on 4/25/11.
//  Copyright 2011 Bryce Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMD_CalculatorViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    // the following are variables used to make the UI function
	IBOutlet UIPickerView* picker;
	NSArray* pickerArray;
	IBOutlet UITextField* birth;
	IBOutlet UITextField* bal;
	IBOutlet UITextField* rmd;
    IBOutlet UITextField* year;
    IBOutlet UIToolbar* yt;
    IBOutlet UIToolbar* dt;
    IBOutlet UIDatePicker* dpicker;

}

@property (nonatomic, retain) UIPickerView* picker;
@property (nonatomic, retain) NSArray* pickerArray;
@property (nonatomic, retain) IBOutlet UITextField* birth;
@property (nonatomic, retain) IBOutlet UITextField* bal;
@property (nonatomic, retain) IBOutlet UITextField* rmd;
@property (nonatomic, retain) IBOutlet UITextField* year;
@property (nonatomic, retain) IBOutlet UIToolbar* yt;
@property (nonatomic, retain) IBOutlet UIToolbar* dt;
@property (nonatomic, retain) IBOutlet UIDatePicker* dpicker;

// the following are methods used for making things like buttons and pickers functional
- (IBAction)calc:(id)sender;
- (IBAction)displayYear;
- (IBAction)displayBirth;
- (IBAction)setYear;
- (IBAction)setB;
- (IBAction)saveData:(id)sender;
- (IBAction)loadData;

// method to simplify saving and load to use new functionality
- (BOOL*)save;
- (BOOL*)load;

// methods for file export
- (BOOL*)exportXML;
- (BOOL*)importXML;
@end

