//
//  WeightViewController.h
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/4/13.
//  Copyright (c) 2013 NIDDK, NIH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightViewController : UIViewController
{
    __weak IBOutlet UITextField *activityChangeField;
    __weak IBOutlet UISegmentedControl *activityChangeSwitch;
    __weak IBOutlet UITextField *endDayField;
    __weak IBOutlet UITextField *newIntakeField;
    __weak IBOutlet UITextField *intakeChangeField;
    __weak IBOutlet UILabel *maintenanceIntakeField;
    __weak IBOutlet UITextField *newWeightField;
    __weak IBOutlet UISegmentedControl *intakeUnitSwitch;
    __weak IBOutlet UISegmentedControl *weightUnitSwitch;
    __weak IBOutlet UILabel *maintenanceLabel;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;    
    __weak IBOutlet UISegmentedControl *intakeSignSwitch;
}
- (IBAction)showBaselineView:(id)sender;
- (IBAction)run:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)showGraph:(id)sender;
- (IBAction)showHelp:(id)sender;

- (IBAction)changeIntakeUnit:(id)sender;
- (IBAction)changeWeightUnit:(id)sender;
- (IBAction)changeIntakeSign:(id)sender;



- (void) animateTextField: (UITextField*) textField: (BOOL) up;
- (void)setAttributes;

@end
