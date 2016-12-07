//
//  PALViewController.h
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PALViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIPickerView *acvitityPicker;
    __weak IBOutlet UILabel *workActivityLable;
    __weak IBOutlet UILabel *leisureActivityLable;
 
    NSArray *workActivityArray;
    NSArray *leisureActivityArray;
    NSArray *workActivityDescriptions;
    NSArray *leisureActivityDescriptions;
    
}

@property (nonatomic, strong) Person *person;

@end
