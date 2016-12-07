//
//  GraphView.m
//  BWSimulatorOS
//
//  Created by Carson Chow on 1/26/13.
//
//

#import "GraphView.h"
#import "Person.h"
#import "PersonStore.h"

NSString * const endDayGVPrefKey = @"endDayPrefKey";
NSString * const weightUnitGVPrefKey = @"weightUnitWVCPrefKey";

@implementation GraphView

@synthesize person;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    CGPoint center;
    
    center.x = bounds.origin.x + bounds.size.width/2.0;
    center.y = bounds.origin.y + bounds.size.height/2.0;
    
    NSString *text = @"BW";
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGRect textRect;
    
    textRect.size = [text sizeWithFont:font];
    
    textRect.origin.x = bounds.origin.x + .5*textRect.size.width;
    textRect.origin.y = bounds.origin.y + bounds.size.height/2.5;
    
    [text drawInRect:textRect withFont:font];
    
    NSString *textDays = @"Days";
    
    UIFont *fontDays = [UIFont systemFontOfSize:17];
    
    CGRect textDaysRect;
    
    textDaysRect.size = [textDays sizeWithFont:fontDays];
    
    textDaysRect.origin.x = center.x;
    textDaysRect.origin.y = bounds.origin.y + 3*bounds.size.height/4.0;
    
    [textDays drawInRect:textDaysRect withFont:fontDays];

    
    CGRect graph;
    
    graph.origin.x = bounds.size.width/5.0;
    graph.origin.y = bounds.size.height/5.0;
    
    graph.size.width = 3*bounds.size.width/4.0;
    graph.size.height = bounds.size.height/2.0;
    
    CGRect strokeRect = CGRectInset(graph, 1.0, 1.0);
    
    CGContextStrokeRect(ctx, strokeRect);
    
    NSInteger weightUnitValue = [[NSUserDefaults standardUserDefaults]
                                 integerForKey:weightUnitGVPrefKey];
    
    double weightInitial = [person weightInitial]*(1+weightUnitValue*(2.2-1));
    
    double daysTotal = 1.0*[[NSUserDefaults standardUserDefaults] integerForKey:endDayGVPrefKey];
    
    NSString *textOrigin = @"0";
    NSString *textDaysTotal = [NSString stringWithFormat:@"%ld",lround(daysTotal)];
    NSString *textWeight = [NSString stringWithFormat:@"%ld",lround(weightInitial)];
    
    CGRect textWeightOriginRect, textWeightRect, textDaysOriginRect, textDaysTotalRect;
    
    textDaysOriginRect.size = [textOrigin sizeWithFont:fontDays];
    textDaysTotalRect.size = [textDays sizeWithFont:fontDays];
    textWeightOriginRect.size = [textOrigin sizeWithFont:fontDays];
    textWeightRect.size = [textWeight sizeWithFont:fontDays];
    
    textDaysOriginRect.origin.x = graph.origin.x ;
    textDaysOriginRect.origin.y = graph.origin.y + graph.size.height;
    
    textDaysTotalRect.origin.x = graph.origin.x + graph.size.width - .5*textDaysTotalRect.size.width;
    textDaysTotalRect.origin.y = graph.origin.y + graph.size.height;
    
    textWeightOriginRect.origin.x = graph.origin.x - 2.0*textWeightOriginRect.size.width;
    textWeightOriginRect.origin.y = graph.origin.y + graph.size.height - .5* textWeightOriginRect.size.height;
    
    textWeightRect.origin.x = graph.origin.x - 1.5*textWeightRect.size.width;
    textWeightRect.origin.y = graph.origin.y - .5* textWeightRect.size.height;
    

    [textOrigin drawInRect:textDaysOriginRect withFont:fontDays];
    
    [textOrigin drawInRect:textWeightOriginRect withFont:fontDays];
    
    [textDaysTotal drawInRect:textDaysTotalRect withFont:fontDays];
    
    [textWeight drawInRect:textWeightRect withFont:fontDays];
    
    //   float maxRadius = hypotf(bounds.size.width, bounds.size.height)/4.0;
    
    //   CGContextSetLineWidth(ctx, 10);
    
    //   CGContextSetRGBStrokeColor(ctx, .6, .6, .6, 1.0);
    
    
    if ([person intake] >0) {
    
    CGPoint point;
    
    float maxRadius = 0.5;
    for (int i=1; i<daysTotal; i++)
    {
    
        [person stepper:i];
        
        point.x = graph.origin.x + graph.size.width*i/(daysTotal);
        point.y = graph.origin.y + graph.size.height*([person weightInitial]-[person weight])/[person weightInitial];


        CGContextAddArc(ctx, point.x, point.y, maxRadius, 0.0, M_PI*2.0,YES);
   
        CGContextStrokePath(ctx);
    
    }
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
            NSLog(@"%g, %g, %g, %g",[person pal],[person palInitial],[person weightInitial],[person weight]);
  
}




@end
