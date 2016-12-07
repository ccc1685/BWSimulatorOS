//
//  Person.h
//  BWSimulator
//
//  Created by Carson Chow on 3/20/12.
//  Copyright (c) 2012 NIDDK, NIH. All rights reserved.
//

#import <Foundation/Foundation.h>


extern double const beta;
extern double const beta_tef;
extern double const beta_therm;

extern double const eta_L;
extern double const eta_F;

extern double const gamma_L;
extern double const gamma_F;

extern double const rho_F;	
extern double const rho_L;
extern double const rho_c;
extern double const hg;

extern double const Cf;
extern double const C;
extern double const deltaEInitial;

extern double const carb_power;
extern double const tau_therm;

extern double const Na_conc;
extern double const Na_zero_CIn;
extern double const Na_ecw;

extern double const dt;

@interface Person : NSObject
{
    // Attributes of a person
    
    unsigned int sex;
    unsigned int age;
    double height;
    double weightInitial;
    double intakeInitial;
    double glycogenInitial;
    double palInitial;
    double intake;
    double pal;
    double therm;
    double NaBaseline;
    double carbFracBaseline;
    double weight;
    double fat;
    double lean;
    double glycogen;
    double deltaExtraCellularWater;
}

@property unsigned int sex;  // 1 is female, 0 is male
@property unsigned int age;
@property double height;
@property double weightInitial;
@property double intakeInitial;
@property double glycogenInitial;
@property double palInitial;
@property double intake;
@property double pal;
@property double therm;
@property double NaBaseline;
@property double carbFracBaseline;
@property double weight;
@property double fat;
@property double lean;
@property double glycogen;
@property double deltaExtraCellularWater;


- (double) bmi;
- (double) fatInitial;
- (double) fatFrac;
- (double) Na;
- (double) rmrInitial;
- (double) teeInitial;
- (double) deltaInit;
- (double) carbIntakeBaseline;
- (double) carbIntake;
- (double) kCarb;
- (double) energyExpenditure;
- (double) pRatio;
- (double) delta: (double) paldelta : (double) weightdelta;
- (double) carbFlux;
- (double) dTherm;
- (double) dGlycogen;
- (double) dFat;
- (double) dLean;
- (double) deltaExtraCellularWater;
- (int) euler;
- (int) rk4;
- (int) stepper:(double) t;
- (int) findIntake:(double) goalweight: (double) t;
- (double) findMaintenanceIntake:(double) maintainenceWeight;




@end
