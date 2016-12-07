//
//  GoalweightViewController.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GoalweightViewController.h"
#import "Person.h"

@implementation GoalweightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        
        [tbi setTitle:@"Set Goal Weight"];
        
 //       UIImage *i = [UIImage imageNamed:@"Time.png"];
        
 //       [tbi setImage:i];
    }
    return self;

}

@end
