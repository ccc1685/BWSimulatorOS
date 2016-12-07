//
//  PALViewController.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PALViewController.h"
#import "BaseViewController.h"
#import "Person.h"

float palValuesArray[5][4];


@implementation PALViewController

@synthesize person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *tbi = [self navigationItem];
        
        [tbi setTitle:@"Physical Activity"];
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

- (void)viewDidLoad
{
    

    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    
     workActivityArray = [[NSArray alloc] initWithObjects:@"Very Light",@"Light",@"Moderate",@"Heavy", nil];
    leisureActivityArray = [[NSArray alloc] initWithObjects:@"Very Light",@"Light", @"Moderate",@"Active",@"Very Active", nil];
    
    workActivityDescriptions = [[NSArray alloc] initWithObjects:@"Very light work, eg. Sitting at desk most of the day",@"Light work, e.g. sales or office work with some movement",@"Moderate work, eg. Cleaning, kitchen work, delivery by foot or bicycle",@"Heavy work, eg. Construction, heavy industrial work", nil];
    
    leisureActivityDescriptions = [[NSArray alloc] initWithObjects:@"Almost no physical activity at all",@"Light activity once a week, eg. walking, easy cycling, gardening",@"Regular activity at least once a week, eg. brisk walking",@"Regular sporting activities more than once a week",@"Strenuous activities more than once a week",nil];
    
    [workActivityLable setText:[workActivityDescriptions objectAtIndex:0]];
    [leisureActivityLable setText:[leisureActivityDescriptions objectAtIndex:0]];

    
    //pal values  (leisure PAL, work PAL)

    palValuesArray[0][0] = 1.4;
    palValuesArray[0][1] = 1.5;
    palValuesArray[0][2] = 1.6;
    palValuesArray[0][3] = 1.7;
    
    palValuesArray[1][0] = 1.5;
    palValuesArray[1][1] = 1.6;
    palValuesArray[1][2] = 1.7;
    palValuesArray[1][3] = 1.8;
    
    palValuesArray[2][0] = 1.6;
    palValuesArray[2][1] = 1.7;
    palValuesArray[2][2] = 1.8;
    palValuesArray[2][3] = 1.9;
    
    palValuesArray[3][0] = 1.7;
    palValuesArray[3][1] = 1.8;
    palValuesArray[3][2] = 1.9;
    palValuesArray[3][3] = 2.1;
    
    palValuesArray[4][0] = 1.9;
    palValuesArray[4][1] = 2.0;
    palValuesArray[4][2] = 2.2;
    palValuesArray[4][3] = 2.3;
    
//    [acvitityPicker selectRow:0 inComponent:0 animated:YES];
//    [acvitityPicker selectRow:1 inComponent:1 animated:YES];

}

- (void)viewDidUnload
{
    acvitityPicker = nil;
    workActivityLable = nil;
    leisureActivityLable = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
     [acvitityPicker selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"picker0"]
     inComponent:0 animated:YES];
    
     [acvitityPicker selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"picker1"]
     inComponent:1 animated:YES];
    NSLog(@"picker Will Appear");

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - UIPickerView Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [workActivityArray count];
    else
        return [leisureActivityArray count];
}
            
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [workActivityArray objectAtIndex:row];
    } else
        return [leisureActivityArray objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    int workRow = [pickerView selectedRowInComponent:0];
    
    int leisureRow = [pickerView selectedRowInComponent:1];
    
    double pal=palValuesArray[leisureRow][workRow];

    [workActivityLable setText:[workActivityDescriptions objectAtIndex:workRow]];
    [leisureActivityLable setText:[leisureActivityDescriptions objectAtIndex:leisureRow]];
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:component];
    NSString *key = [NSString stringWithFormat:@"picker%d", component];
    
    [[NSUserDefaults standardUserDefaults] setInteger:selectedRow forKey:key];


    NSLog(@"PAL = %g",pal);
    [person setPalInitial:pal];
    
}
            
@end
