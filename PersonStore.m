//
//  PersonStore.m
//  BWsim
//
//  Created by Carson Chow on 12/30/12.
//  Copyright (c) 2012 NIDDK, NIH. All rights reserved.
//

#import "PersonStore.h"
#import "Person.h"

@implementation PersonStore

+ (PersonStore *)sharedStore
{
    static PersonStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super self];
    if (self) {
        allPersons = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allPersons
{
    return allPersons;
}

- (Person *)createPerson
{
    
    Person *person = [[Person alloc] init];
    
    [person setSex:1];
    [person setAge:40];
    [person setHeight:1.63];
    [person setWeightInitial:80];
    [person setPalInitial:1.6];
    [person setPal:1.6];
    [person setIntakeInitial:[person teeInitial]];
    [person setGlycogenInitial:0.5];
    [person setNaBaseline:4000];  
    [person setCarbFracBaseline:0.5];
    
    // Initial values for changeable parameters
//    [person setWeight:[person weightInitial]];
//    [person setIntake:[person intakeInitial]];
    
    // Initial conditions for dynamic variables
    [person setTherm:beta_therm*[person intakeInitial]];
    [person setFat:[person fatInitial]];
    [person setLean:[person weight]-[person fat]];
    [person setGlycogen:[person glycogenInitial]];
    [person setDeltaExtraCellularWater:0];
    
    //     double b = [person bmiInitial];
    //      NSLog(@"BMI is %f",b);
    
//    NSLog(@"F=%f, L=%f, BW=%f, bmi=%f, therm=%f, intake=%f",[person fat], [person lean],[person weight],[person bmi],[person therm], [person intakeInitial]);
//    [person setIntake:[person intakeInitial]-100];
    
//    [person stepper:k];
//    NSLog(@"F is now %f, L is %f, BW is %f, g is %f, decw is %f, bmi is %f, therm is %f, fatfrac is %f",[person fat], [person lean],[person weight],[person glycogen],[person deltaExtraCellularWater],[person bmi],[person therm], [person fatFrac]);
    

    [allPersons addObject:person];
    
    return person;
}
@end
