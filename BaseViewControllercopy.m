//
//  BaseViewController.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/2/13.
//  Copyright (c) 2013 NIDDK, NIH. All rights reserved.
//

#import "BaseViewController.h"
#import "Person.h"

@implementation BaseViewController

@synthesize person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        UINavigationItem *tbi = [self navigationItem];
        
        [tbi setTitle:@"Baseline Information"];
        
        //       UIImage *i = [UIImage imageNamed:@"Time.png"];
        
        //       [tbi setImage:i];
    }
    return self;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ageField setText:[NSString stringWithFormat:@"%d", [person age]]];
    [heightField setText:[NSString stringWithFormat:@"%g", [person height]*100]];
    [palField setText:[NSString stringWithFormat:@"%g", [person palInitial]]];
    [intakeField setText:[NSString stringWithFormat:@"%g", [person teeInitial]]];
    [weightField setText:[NSString stringWithFormat:@"%g", [person weightInitial]]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    
    [person setAge:[[ageField text] intValue]];
    
    // Convert sex field into integer 1 = female, 0 = male
    
    NSString * sextext = [sexField text];
    const char * c = [sextext UTF8String];

    if (strncmp(c,"M",1)==0 || strncmp(c,"m",1)==0) {
        [person setSex:0];
    }
    else
        [person setSex:1];

    [person setHeight:[[heightField text] doubleValue/100]];
    [person setPalInitial:[[palField text] doubleValue]];
//    [person setIntakeInitial:[[intakeField text] doubleValue]];
    [person setWeightInitial:[[weightField text] doubleValue]];
    
    
    NSLog(@"Age is %d",[person age]);
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [intakeField setText:[NSString stringWithFormat:@"%g", [person teeInitial]]];
    [textField resignFirstResponder];
        [self setAttributes];
    
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
    



- (void)setAttributes
{
    int age = [[ageField text] intValue];
    NSString * sextext = [sexField text];
    
    const char * c = [sextext UTF8String];
    
    int sex = 1;
    
    NSLog(@"%d, %d",strncmp(c,"M",1)==0, strncmp(c, "m", 1));

    if (strncmp(c,"M",1)==0 || strncmp(c,"m",1)==0) {
        sex = 0;
    }
    
    double height = [[heightField text] doubleValue];
    double pal = [[palField text] doubleValue];
    double intake = [[intakeField text] doubleValue];
    double weight = [[weightField text] doubleValue];
    
    
    NSLog(@"Age is %d, Sex is %d, Height is %g, pal is %g, intake is %g, weight is %g",age,sex,height,pal,intake,weight);
 
}

- (void)viewDidUnload {
    ageField = nil;
    [super viewDidUnload];
}
@end