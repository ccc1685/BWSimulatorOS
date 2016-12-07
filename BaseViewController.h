//
//  BaseViewController.h
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/2/13.
//  Copyright (c) 2013 NIDDK, NIH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface BaseViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *ageField;
    __weak IBOutlet UILabel *palField;
    __weak IBOutlet UITextField *heightField;
    __weak IBOutlet UILabel *intakeField;
    __weak IBOutlet UITextField *weightField;
    __weak IBOutlet UISegmentedControl *sexSwitch;
    __weak IBOutlet UISegmentedControl *heightUnitSwitch;
    __weak IBOutlet UISegmentedControl *intakeUnitSwitch;
    __weak IBOutlet UISegmentedControl *weightUnitSwitch;
    
}
@property (nonatomic, strong) Person *person;

- (void) animateTextField: (UITextField*) textField: (BOOL) up;

- (IBAction)changeSex:(id)sender;
- (IBAction)changeIntakeUnit:(id)sender;
- (IBAction)changeWeightUnit:(id)sender;
- (IBAction)changeHeightUnit:(id)sender;
- (IBAction)showEstimatePAL:(id)sender;


@end
