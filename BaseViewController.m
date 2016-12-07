//
//  BaseViewController.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/2/13.
//  Copyright (c) 2013 NIDDK, NIH. All rights reserved.
//

#import "BaseViewController.h"
#import "PALViewController.h"
#import "HelpView2Controller.h"
#import "Person.h"


NSString * const sexPrefKey = @"sexPrefKey";
NSString * const weightUnitPrefKey = @"weightUnitPrefKey";
NSString * const intakeUnitPrefKey = @"intakeUnitPrefKey";
NSString * const heightUnitPrefKey = @"heightUnitPrefKey";
NSString * const ageKey = @"ageKey";
NSString * const weightInitKey = @"weightInitKey";
NSString * const heightKey = @"heightKey";
NSString * const intakeInitKey = @"intakeInitKey";
NSString * const palInitKey = @"palInitKey";
NSString * const firstBVCOpening = @"firstBVOpening";

@implementation BaseViewController

@synthesize person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        UINavigationItem *tbi = [self navigationItem];
        
        [tbi setTitle:@"Baseline Info"];
        
        // Create bar button
        
        UIBarButtonItem *bbi =  [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(showHelp:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];


    }
    return self;    
}

- (void) viewDidLoad
{
    NSInteger sexValue = [[NSUserDefaults standardUserDefaults]
                          integerForKey:sexPrefKey];
    
    [sexSwitch setSelectedSegmentIndex:sexValue];
    
    [self changeSex:sexSwitch];
    
    NSInteger heightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:heightUnitPrefKey];
    
    [heightUnitSwitch setSelectedSegmentIndex:heightUnitValue];
    
    [self changeHeightUnit:heightUnitSwitch];
    
    NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitPrefKey];
    
    [weightUnitSwitch setSelectedSegmentIndex:weightUnitValue];
    
    [self changeWeightUnit:weightUnitSwitch];
    
    NSInteger intakeUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:intakeUnitPrefKey];
    
    [intakeUnitSwitch setSelectedSegmentIndex:intakeUnitValue];
    
    [self changeIntakeUnit:intakeUnitSwitch];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:firstBVCOpening])
    {
        [person setAge:[[NSUserDefaults standardUserDefaults] integerForKey:ageKey]];
        [person setHeight:[[NSUserDefaults standardUserDefaults] doubleForKey:heightKey]];
        [person setWeightInitial:[[NSUserDefaults standardUserDefaults] doubleForKey:weightInitKey]];
        [person setPalInitial:[[NSUserDefaults standardUserDefaults] doubleForKey:palInitKey]];
        NSLog(@"not first time");
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstBVCOpening];
    
    }
    

}

- (void)viewDidUnload {
    
    ageField = nil;
    sexSwitch = nil;
    palField = nil;
    heightUnitSwitch = nil;
    intakeUnitSwitch = nil;
    weightUnitSwitch = nil;
    intakeField = nil;
    [super viewDidUnload];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger heightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:heightUnitPrefKey];
    NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitPrefKey];
    NSInteger intakeUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:intakeUnitPrefKey];
    
    [ageField setText:[NSString stringWithFormat:@"%d", [person age]]];
 
    [heightField setText:[NSString stringWithFormat:@"%.00f", [person height]*(1+heightUnitValue*(.3937 -1))*100]];
    
    [palField setText:[NSString stringWithFormat:@"%g", [person palInitial]]];
    
    [intakeField setText:[NSString stringWithFormat:@"%ld", lroundf([person teeInitial]*(1+intakeUnitValue*(4.184-1)))]];
    
    [weightField setText:[NSString stringWithFormat:@"%g", [person weightInitial]*(1+weightUnitValue*(2.2-1))]];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    
    NSInteger heightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:heightUnitPrefKey];
    NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitPrefKey];
    
    [person setAge:[[ageField text] intValue]];

    [person setHeight:[[heightField text] doubleValue]*(1+heightUnitValue*(1/.3937 -1))/100];
    [person setPalInitial:[[palField text] doubleValue]];
    [person setWeightInitial:[[weightField text] doubleValue]*(1+weightUnitValue*(1/2.2-1))];
    
    [person setIntakeInitial:[[intakeField text] doubleValue]];
    
    [[NSUserDefaults standardUserDefaults] setInteger:[person age] forKey:ageKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person height] forKey:heightKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person weightInitial] forKey:weightInitKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person intakeInitial] forKey:intakeInitKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person palInitial] forKey:palInitKey];
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSInteger heightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:heightUnitPrefKey];
    NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitPrefKey];

    [person setHeight:[[heightField text] doubleValue]*(1+heightUnitValue*(1/.3937 -1))/100];
    [person setPalInitial:[[palField text] doubleValue]];
    [person setWeightInitial:[[weightField text] doubleValue]*(1+weightUnitValue*(1/2.2-1))];
    
    [intakeField setText:[NSString stringWithFormat:@"%g", [person teeInitial]]];
    
    [[NSUserDefaults standardUserDefaults] setInteger:[person age] forKey:ageKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person height] forKey:heightKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person weightInitial] forKey:weightInitKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[person palInitial] forKey:palInitKey];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField: NO];
}


- (void) animateTextField: (UITextField*) textField: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = 320-(480-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3; 
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);       
        [UIView commitAnimations];
    }
}


- (IBAction)changeSex:(id)sender
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:sexPrefKey];

    switch ([sender selectedSegmentIndex]) {
        case 0: {
            [person setSex:1];
//            NSLog(@"female");
        } break;
            
        case 1: {
            [person setSex:0];
//            NSLog(@"male");
        } break;
    }
}

- (IBAction)changeIntakeUnit:(id)sender
{
//    NSLog(@"segment is %d",[sender selectedSegmentIndex]);
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:intakeUnitPrefKey];

    
    switch ([sender selectedSegmentIndex]) {
        case 1: {
                
            [intakeField setText:[NSString stringWithFormat:@"%ld", lround([person teeInitial]*4.184)]];
//            NSLog(@"KJ");
            
        }  break;
            
        default:
            [intakeField setText:[NSString stringWithFormat:@"%ld", lround([person teeInitial])]];
//            NSLog(@"Cal");
            break;
    }
}

- (IBAction)changeWeightUnit:(id)sender
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:weightUnitPrefKey];

    switch ([sender selectedSegmentIndex]) {
        case 1: {
            
            [weightField setText:[NSString stringWithFormat:@"%g", [person weightInitial]*2.2]];
//            NSLog(@"lbs");
            
        }  break;
            
        default:
            [weightField setText:[NSString stringWithFormat:@"%g", [person weightInitial]]];
//            NSLog(@"Kg");
            break;
    }
}

- (IBAction)changeHeightUnit:(id)sender
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:heightUnitPrefKey];
    switch ([sender selectedSegmentIndex]) {
        case 1: {
            
            [heightField setText:[NSString stringWithFormat:@"%.01f", [person height]*39.37]];
//            NSLog(@"inches");
            
        }  break;
            
        default:
            [heightField setText:[NSString stringWithFormat:@"%.00f", [person height]*100]];
//            NSLog(@"m");
            break;
    }
}

- (IBAction)showEstimatePAL:(id)sender
{
    PALViewController *palViewController = [[PALViewController alloc] init];
        [[self navigationController] pushViewController:palViewController animated:YES];
    
    [palViewController setPerson:person];
    
    NSLog(@"estimatePAL");

}

- (IBAction)showHelp:(id)sender
{
    HelpView2Controller *helpViewController = [[HelpView2Controller alloc] init];
    [[self navigationController] pushViewController:helpViewController animated:YES];
}


@end