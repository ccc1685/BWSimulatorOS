//
//  GraphViewController.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/25/13.
//
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "Person.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    GraphView *v = [[GraphView alloc] initWithFrame:frame];
    
    [v setPerson:person];
    
    [v setBackgroundColor:[UIColor whiteColor]];
    
    [self setView:v];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
