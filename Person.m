//
//  Person.m
//  BWSimulator
//
//  Created by Carson Chow on 3/20/12.
//  Copyright (c) 2012 NIDDK, NIH. All rights reserved.
//

#import "Person.h"

// global constants

double const beta = 0.24;
double const beta_tef = 0.1;
double const beta_therm = beta - beta_tef;

double const eta_L= 230;
double const eta_F = 18;  // 180 in Madonna code

double const gamma_L = 22;
double const gamma_F = 3.2;

double const rho_F = 9440;
double const rho_L = 1807;
double const rho_c = 4180;
double const hg = 2.7;

double const Cf = 10.4;
double const C = Cf*rho_L/rho_F;
double const deltaEInitial = 0;

double const carb_power=2;
double const tau_therm=14;

double const Na_conc = 3220;	// in mg/L
double const Na_zero_CIn = 4000; // in mg/d
double const Na_ecw = 3000;	

double const dt=.5;

@implementation Person

@synthesize sex;
@synthesize age;
@synthesize height;
@synthesize weightInitial;
@synthesize intakeInitial;
@synthesize glycogenInitial;
@synthesize palInitial;
@synthesize weight;
@synthesize fat;
@synthesize lean;
@synthesize intake;
@synthesize glycogen;
@synthesize deltaExtraCellularWater;
@synthesize pal;
@synthesize therm;
@synthesize NaBaseline;
@synthesize carbFracBaseline;


- (double) bmiInitial
{
    return [self weightInitial] / ([self height]*[self height]);
}

- (double) bmi
{
    return [self weight]/([self height]*[self height]);
}

// Initial body fat using Jackson's equations
- (double) fatInitial
{
    double fatTest;
    
    if (sex==1) { 
        // women
        fatTest = (-102.01+39.96*log([self bmiInitial])+0.14*[self age])/100*[self weightInitial];
    } 
    else {
        // men
        fatTest = (-103.94+37.31*log([self bmiInitial])+0.14*[self age])/100*[self weightInitial];
    }
    // fat capped at .6 bodyweight
    if (fatTest > 0.6*[self weightInitial]) {
        fatTest = 0.6*[self weightInitial];
    }
    return fatTest;
}

- (double) fatFrac
{
    return [self fat]/[self weight];
}

- (double) Na
{
    return [self NaBaseline]*[self intake]/[self intakeInitial];
}

// Initial resting metabolic rate
- (double) rmrInitial
{
    if (sex==1) { // women
        return 9.99*[self weightInitial] + 625*[self height] - 4.92*[self age] - 161;
        
    }
    else { // men
        return 9.99*[self weightInitial] + 625*[self height] - 4.92*[self age] +5; 
    }
    
}

- (double) teeInitial
{
 //   return [self palInitial]*[self rmrInitial];
    return [self palInitial]*[self rmrInitial];
}

- (double) deltaInit
{
    return ((1-beta_tef)*[self teeInitial] - [self rmrInitial])/[self weightInitial];
}

- (double) delta:(double)paldelta :(double) weightdelta
{
    return ((1-beta_tef)*paldelta-1)*[self rmrInitial]/weightdelta;
}


- (double) carbIntake
{
    return [self carbFracBaseline]*intake;
}

- (double) carbIntakeBaseline
{
    return carbFracBaseline*[self intakeInitial];
}

- (double) kCarb
{
    return [self carbIntakeBaseline]/pow(glycogenInitial,carb_power);
}

- (double) pRatio
{
    return C/(C+fat);
}


- (double) energyExpenditure
{
/*
    double K = (1-beta)*intakeInitial -deltaEInitial - gamma_L*(weightInitial - [self fatInitial]) - gamma_F*[self fatInitial] - [self palInitial]*weightInitial;
    
    double expend = K + gamma_L*[self lean] + gamma_F*[self fat] + [self pal]*weight + [self therm] + beta_tef*[self intake];
    
    return (expend + (intake - [self carbFlux])*((1-[self pRatio])*eta_F/rho_F+[self pRatio]*eta_L/rho_L))/(1+[self pRatio]*eta_L/rho_L+(1-[self pRatio])*eta_F/rho_F);
*/
    double K = (1-beta)*[self intakeInitial] -deltaEInitial - gamma_L*([self weightInitial]
            - [self fatInitial]) - gamma_F*[self fatInitial] - [self deltaInit]*[self weightInitial];
    
    double expend = K + gamma_L*[self lean] + gamma_F*[self fat] + [self delta:[self pal]:[self weightInitial]]*[self weight] + [self therm] + beta_tef*[self intake];
    
//    double expend = K + gamma_L*[self lean] + gamma_F*[self fat] + [self deltaInit]*[self weight] + [self therm] + beta_tef*[self intake];
    
    return (expend + ([self intake] - [self carbFlux])*((1-[self pRatio])*eta_F/rho_F+[self pRatio]*eta_L/rho_L))/(1+[self pRatio]*eta_L/rho_L+(1-[self pRatio])*eta_F/rho_F);
}

- (double) carbFlux
{
    return [self carbIntake] - [self kCarb]*pow([self glycogen],carb_power);
}

- (double) dTherm
{
    return (beta_therm*intake -therm)/tau_therm;
}

- (double) dGlycogen
{
    return ([self carbIntake] - [self kCarb]*pow([self glycogen],carb_power))/rho_c;
}

- (double) dFat
{
    return (1-[self pRatio])*([self intake]-[self energyExpenditure]- [self carbFlux])/rho_F;
}

- (double) dLean
{
    return [self pRatio]*([self intake]-[self energyExpenditure]-[self carbFlux])/rho_L;
}

- (double) dDeltaExtraCellularWater
{
    return ([self Na]-[self NaBaseline]-Na_ecw*[self deltaExtraCellularWater] - Na_zero_CIn*(1-[self carbIntake]/[self carbIntakeBaseline]))/Na_conc;
}

- (int) euler
{
        fat += dt*[self dFat];
        lean += dt*[self dLean];
        glycogen += dt*[self dGlycogen];
        therm += dt*[self dTherm];
        deltaExtraCellularWater += dt*[self dDeltaExtraCellularWater];
        [self setWeight:fat+lean+deltaExtraCellularWater+(1+hg)*(glycogen-glycogenInitial)];

    return 0;
}

- (int) rk4
{
    double h=dt*(1+dt/2+dt*dt/6+dt*dt*dt/24);
    
    fat += h*[self dFat];
    lean += h*[self dLean];
    glycogen += h*[self dGlycogen];
    therm += h*[self dTherm];
    deltaExtraCellularWater += dt*[self dDeltaExtraCellularWater];
    [self setWeight:fat+lean+deltaExtraCellularWater+(1+hg)*(glycogen-glycogenInitial)];
    
    return 0;
}

- (int) stepper: (double) t
{    
    int total=t/dt;
    
    // Initial conditions for dynamic variables
    [self setTherm:beta_therm*[self intakeInitial]];
    [self setFat:[self fatInitial]];
    [self setLean:[self weightInitial]-[self fatInitial]];
    [self setGlycogen:[self glycogenInitial]];
    [self setDeltaExtraCellularWater:0];
    [self setWeight:fat+lean+deltaExtraCellularWater+(1+hg)*(glycogen-glycogenInitial)];
    
//    NSLog(@"F=%f, L=%f, BW=%f, bmi=%f, pal=%f, intake=%f, height=%f",[self fat], [self lean],[self weight],[self bmi],[self pal], [self intake], [self height]);
    
    for (int i=0;i<total;i++) 
    {    
        //[self rk4];
        [self euler];
    }
//    NSLog(@"F=%f, L=%f, BW=%f, bmi=%f, therm=%f, intake=%f, ",[self fat], [self lean],[self weight],[self bmi],[self therm], [self intakeInitial]);
    
    return 0;
}

- (int) findIntake:(double) goalWeight: (double) t;
{
    double currentIntake = [self weight]*22;
    [self setIntake:currentIntake];
    [self stepper:t];
    double currentWeight = [self weight];
    double error = currentWeight-goalWeight;
    int iterations = 0;
    while (fabs(error)>.01 && iterations < 10) {
        [self setIntake:(currentIntake+1)];
        [self stepper:t];
        double dWeight = ([self weight]-currentWeight);
        currentIntake-=error/dWeight;
        
        [self setIntake:currentIntake];
        [self stepper:t];
        currentWeight = [self weight];
                
        error = (currentWeight-goalWeight);
        iterations++;
//        NSLog(@"%d, %g, %g, %g, %g, %g",iterations,error,currentIntake, currentWeight, dWeight, goalWeight);
    }

    
    return 0;
}

- (double) findMaintenanceIntake:(double) maintenanceWeight
{
    double t =4000;
    double currentIntake = [self weight]*22;
    [self setIntake:currentIntake];
    [self stepper:t];
    double currentWeight = [self weight];
    double error = currentWeight-maintenanceWeight;
    int iterations = 0;
    while (fabs(error)>.01 && iterations < 10) {
        [self setIntake:(currentIntake+1)];
        [self stepper:t];
        double dWeight = ([self weight]-currentWeight);
        currentIntake-=error/dWeight;
        
        [self setIntake:currentIntake];
        [self stepper:t];
        currentWeight = [self weight];
        
        error = (currentWeight-maintenanceWeight);
        iterations++;

    }
 //       NSLog(@"%d, %g, %g, %g, %g",iterations,error,currentIntake, currentWeight, maintenanceWeight);
    
    return currentIntake;
}

@end
