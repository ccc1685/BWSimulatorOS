//
//  WeightViewController.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/4/13.
//  Copyright (c) 2013 NIDDK, NIH. All rights reserved.
//

#import "WeightViewController.h"
#import "BaseViewController.h"
#import "NewPALViewController.h"
#import "HelpView2Controller.h"
#import "GraphViewController.h"
#import "PersonStore.h"
#import "Person.h"

// NSUserDefault strings

NSString * const firstOpening = @"firstWVCOpening";
NSString * const weightUnitWVCPrefKey = @"weightUnitWVCPrefKey";
NSString * const intakeUnitWVCPrefKey = @"intakeUnitWVCPrefKey";
NSString * const intakeSignWVCPrefKey = @"intakeSignWVCPrefKey";
NSString * const endDayPrefKey = @"endDayPrefKey";
NSString * const ageWVCKey = @"ageKey";
NSString * const weightInitWVCKey = @"weightInitKey";
NSString * const heightWVCKey = @"heightKey";
NSString * const intakeInitWVCKey = @"intakeInitKey";
NSString * const palInitWVCKey = @"palInitKey";
NSString * const palWVCKey = @"palKey";
NSString * const activitySignWVCPrefKey = @"activitySignWVCPrefKey";

@implementation WeightViewController

- (id)init
{
    self = [super init];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:@"BW Simulator"];
        
        // Create bar button
        
        UIBarButtonItem *bbi =  [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(showHelp:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        for (int i = 0; i < 1; i++) {
            [[PersonStore sharedStore] createPerson];
        }
    }
    return self;
}
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    Person *p = [persons objectAtIndex:0];
    
    double activityChange = 100*fabs([[NSUserDefaults standardUserDefaults] doubleForKey:palWVCKey]-[p palInitial])/[p palInitial];

    [activityChangeField setText:[NSString stringWithFormat:@"%g", activityChange ]];
    
    [endDayField setText:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:endDayPrefKey]]];
    
    NSLog(@"dPA = %g",[[NSUserDefaults standardUserDefaults] doubleForKey:palWVCKey]-[p palInitial]);

}

- (void) viewWillDisappear:(BOOL)animated
{
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    Person *p = [persons objectAtIndex:0];

    [[NSUserDefaults standardUserDefaults] setDouble:[p pal] forKey:palWVCKey];
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[endDayField text] integerValue] forKey:endDayPrefKey];
     NSLog(@"pal %g",[p pal]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    Person *p = [persons objectAtIndex:0];
    
    [activityIndicator stopAnimating];

    // On first opening, go directly to Help
    if (![[NSUserDefaults standardUserDefaults] boolForKey:firstOpening])
    {
        
        // Acknowledge first opening
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstOpening];
        
        // Go to Help View through Baseline View
        
        BaseViewController *baseViewController = [[BaseViewController alloc] init];
        
        NSArray *persons = [[PersonStore sharedStore] allPersons];
        
        Person *p = [persons objectAtIndex:0];
        
        [baseViewController setPerson:p];
        
        [[self navigationController] pushViewController:baseViewController animated:YES];
        
        // Back button in Help View will be Baseline Information
        
        HelpView2Controller *helpViewController = [[HelpView2Controller alloc] init];
        [[self navigationController] pushViewController:helpViewController animated:YES];
        
        //store initial activity value
        [[NSUserDefaults standardUserDefaults] setDouble:[p pal] forKey:palWVCKey];
        

        [[NSUserDefaults standardUserDefaults] setInteger:180 forKey:endDayPrefKey];
        
        [endDayField setText:@"180"];
        
        
    }
    else
    {
        // Set to default values
        NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitWVCPrefKey];
        [weightUnitSwitch setSelectedSegmentIndex:weightUnitValue];
    
    
        NSInteger intakeUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:intakeUnitWVCPrefKey];
        [intakeUnitSwitch setSelectedSegmentIndex:intakeUnitValue];
    
        NSInteger intakeSignValue = [[NSUserDefaults standardUserDefaults] integerForKey:intakeSignWVCPrefKey];
        [intakeSignSwitch setSelectedSegmentIndex:intakeSignValue];
        
        NSInteger activitySignValue = [[NSUserDefaults standardUserDefaults] integerForKey:activitySignWVCPrefKey];
        [activityChangeSwitch setSelectedSegmentIndex:activitySignValue];
        
        [p setAge:[[NSUserDefaults standardUserDefaults] integerForKey:ageWVCKey]];
        
        [p setHeight:[[NSUserDefaults standardUserDefaults] doubleForKey:heightWVCKey]];
        
        [p setWeightInitial:[[NSUserDefaults standardUserDefaults] doubleForKey:weightInitWVCKey]];
        
        [p setIntakeInitial:[[NSUserDefaults standardUserDefaults] doubleForKey:intakeInitWVCKey]];
    
        [p setPal:[[NSUserDefaults standardUserDefaults] doubleForKey:palWVCKey]];
        
        [p setPalInitial:[[NSUserDefaults standardUserDefaults] doubleForKey:palInitWVCKey]];

    }
    
    // Set activity field to current physical activity level
    [activityChangeField setText:[NSString stringWithFormat:@"%g", 100*abs([p pal]-[p palInitial])/[p palInitial]]];
    
    [endDayField setText:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:endDayPrefKey]]];

}

- (void)viewDidUnload
{

    endDayField = nil;
    newIntakeField = nil;
    newWeightField = nil;;
    intakeUnitSwitch = nil;
    maintenanceIntakeField = nil;
    weightUnitSwitch = nil;
    
    maintenanceLabel = nil;
    activityIndicator = nil;
    intakeSignSwitch = nil;
    intakeSignSwitch = nil;
    intakeChangeField = nil;
    activityChangeField = nil;
    activityChangeSwitch = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)showBaselineView:(id)sender
{
    BaseViewController *baseViewController = [[BaseViewController alloc] init];
    
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    
    Person *p = [persons objectAtIndex:0];
    
    [baseViewController setPerson:p];
    
    [[self navigationController] pushViewController:baseViewController animated:YES];

}


- (IBAction)reset:(id)sender
{
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    Person *p = [persons objectAtIndex:0];

    [p setIntake:0];
    
    [maintenanceIntakeField setText:@""];
    [maintenanceLabel setText:@""];
    [newWeightField setText:@""];
    [newIntakeField setText:@""];
    [intakeChangeField setText:@""];

    NSLog(@"reset");
}

#pragma mark - Run

- (IBAction)run:(id)sender
{

    NSArray *persons = [[PersonStore sharedStore] allPersons];
    Person *p = [persons objectAtIndex:0];
    
    NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitWVCPrefKey];
    NSInteger intakeUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:intakeUnitWVCPrefKey];
//    NSInteger activitySign = [[NSUserDefaults standardUserDefaults] integerForKey:activitySignWVCPrefKey];
    
    double totalTime = 1.0*[[endDayField text] intValue ];
    
    if (totalTime > 0) {
    
    double intake =[[newIntakeField text] doubleValue]*(1+intakeUnitValue*(1/4.184-1));
    
    double goalWeight = [[newWeightField text] doubleValue]*(1+weightUnitValue*(1/2.2-1));
    
    [p setPal:[p palInitial]*(1+(2*[activityChangeSwitch selectedSegmentIndex]-1)*[[activityChangeField text] doubleValue]/100)];
    
//    [activityIndicator startAnimating];
    
//        NSLog(@"F=%f, L=%f, BW=%f, bmi=%f, therm=%f, intake=%f, te=%f",[p fatInitial], [p lean],[p weightInitial],[p bmi],[p therm], [p intakeInitial], [p energyExpenditure]);
    if (intake > 0) {
    
        [p setIntake:intake];
    
        [p stepper:totalTime];
        
        [newWeightField setText:[NSString stringWithFormat:@"%ld", lroundf([p weight]*(1+weightUnitValue*(2.2-1)))]];
                       
        [maintenanceLabel setText:@"Maintenance Diet"];
        [maintenanceIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf([p findMaintenanceIntake:[p weight]]*(1+intakeUnitValue*(4.184-1)))]];

    }
        
    else if (goalWeight > 0) {
        
        
        [p findIntake:goalWeight:totalTime];
        
        intake = [p intake];
        
        [newIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf([p intake]*(1+intakeUnitValue*(4.184-1)))]];
        
        
        double intakeChange = ([p intake]-[p intakeInitial])*(1+intakeUnitValue*(4.184-1));
        
        if (intakeChange > 0) {
                [intakeSignSwitch setSelectedSegmentIndex:1];
        } else
            [intakeSignSwitch setSelectedSegmentIndex:0];
        
        
        [intakeChangeField setText:[NSString stringWithFormat:@"%ld",lroundf(abs(intakeChange)*(1+intakeUnitValue*(4.184-1)))]];
        
        [maintenanceLabel setText:@"Maintenance Diet"];
        [maintenanceIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf([p findMaintenanceIntake:goalWeight]*(1+intakeUnitValue*(4.184-1)))]];
        
    }
    [activityIndicator stopAnimating];
    
//    [p setIntake:intake];
    
//            NSLog(@"Intake is %g, Weight is %g, PAL is %g",[p intake],[p weight],[p pal]);

        NSLog(@"F is now %f, L is %f, BW is %f, g is %f, decw is %f, bmi is %f, therm is %f, fatfrac is %f, EE is %f, pal is %f",[p fat], [p lean],[p weight],[p glycogen],[p deltaExtraCellularWater],[p bmi],[p therm], [p fatFrac], [p energyExpenditure], [p pal]);
    }

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField != newWeightField & textField != endDayField)
    [self setAttributes];
        
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


- (IBAction)changeIntakeSign:(id)sender
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:intakeSignWVCPrefKey];
    
    if ([[intakeChangeField text] doubleValue]>0) {
   
        [self setAttributes];
    }
    
//    NSLog(@"%d",-[sender selectedSegmentIndex]);
    
}

- (IBAction)changeIntakeUnit:(id)sender
{

//    NSLog(@"segment is %d",[sender selectedSegmentIndex]);
    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:intakeUnitWVCPrefKey];
    
    double newIntake = [[newIntakeField text] doubleValue];
    
    if (newIntake > 0)
    {
    
    switch ([sender selectedSegmentIndex]) {
        case 1: {
            [newIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf(newIntake*4.184)]];
            [maintenanceIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf([[maintenanceIntakeField text] doubleValue]*4.184)]];

            NSLog(@"KJ");
            
        }  break;
            
        default:
            [newIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf(newIntake/4.184)]];
                        [maintenanceIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf([[maintenanceIntakeField text] doubleValue]/4.184)]];
//            [intakeField setText:[NSString stringWithFormat:@"%g", [person teeInitial]]];
            NSLog(@"Cal");
            break;
    }
    }
}


- (IBAction)changeWeightUnit:(id)sender
{

    [[NSUserDefaults standardUserDefaults]
     setInteger:[sender selectedSegmentIndex] forKey:weightUnitWVCPrefKey];
    
    double newWeight = [[newWeightField text]
                        doubleValue];
    
    if (newWeight > 0){
    
    switch ([sender selectedSegmentIndex]) {
        case 1: {
                
            [newWeightField setText:[NSString stringWithFormat:@"%g", newWeight*2.2]];
            
//            [weightField setText:[NSString stringWithFormat:@"%g", [person weightInitial]*2.2]];
            NSLog(@"lbs");
            
        }  break;
            
        default:
                    
            [newWeightField setText:[NSString stringWithFormat:@"%g", newWeight/2.2]];
//            [weightField setText:[NSString stringWithFormat:@"%g", [person weightInitial]]];
            NSLog(@"Kg");
            break;
    }
    }
}


- (void)setAttributes
{
    double intake;
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    Person *p = [persons objectAtIndex:0];
    NSInteger intakeUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:intakeUnitWVCPrefKey];

    int intakeSign = 2*[[NSUserDefaults standardUserDefaults] integerForKey:intakeSignWVCPrefKey]-1;
    
    double intakeChange=[[intakeChangeField text] doubleValue]*(1+intakeUnitValue*(1/4.184-1));
    
    
    if ([[newIntakeField text] doubleValue]>0)
    {
        
        intake =[[newIntakeField text] doubleValue]*(1+intakeUnitValue*(1/4.184-1));
        intakeChange =  [p intakeInitial] - intake;
        
        [intakeChangeField setText:[NSString stringWithFormat:@"%ld", lroundf(intakeChange*(1+intakeUnitValue*(4.184-1)))]];
        
    }  else {
        
        intake = [p intakeInitial]+ intakeSign*intakeChange;
        
        [p setIntake:intake];
        
        [newIntakeField setText:[NSString stringWithFormat:@"%ld", lroundf(intake*(1+intakeUnitValue*(4.184-1)))]];
    }

    [p setPal:[p palInitial]*(1+(2*[activityChangeSwitch selectedSegmentIndex]-1)*[[activityChangeField text] doubleValue]/100)];
    
}


- (IBAction)showHelp:(id)sender
{
    HelpView2Controller *helpViewController = [[HelpView2Controller alloc] init];
    [[self navigationController] pushViewController:helpViewController animated:YES];
}

- (IBAction)showGraph:(id)sender
{
//    [activityIndicator startAnimating];
    
    NSArray *persons = [[PersonStore sharedStore] allPersons];
    
    Person *p = [persons objectAtIndex:0];
    
    GraphViewController *graphViewController = [[GraphViewController alloc] init];
    
    [graphViewController setPerson:p];
    
    [[self navigationController] pushViewController:graphViewController animated:YES];
}


@end
