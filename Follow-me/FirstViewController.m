//
//  FirstViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "FirstViewController.h"
#import <Stripe/Stripe.h>
#import <QuartzCore/QuartzCore.h>


@interface FirstViewController () <STPPaymentCardTextFieldDelegate>

@property (nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic) UIButton *submitButton;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    totaldist = 0;
    totalstep = 0;
    rewarddist = 200000.00;
    rewardstep = 200000.00;
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    [self createui];
    [self createview];
    self.navigationController.navigationBar.topItem.title = @"快樂猫";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.47 green:0.71 blue:0.23 alpha:0.5]];
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable])
    {
        // Add your HealthKit code here
        NSLog(@"the data is available");
        healthStore = [[HKHealthStore alloc] init];
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                   nil];
        [healthStore requestAuthorizationToShareTypes:nil
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               if(success == YES) {
                                                   NSLog(@"read is success");
                                                   [self readstepHK];
                                                   [self readdist];
                                               } else {
                                                   NSLog(@"the read is not success");
                                               }
                                           }];
        
    } else {
        NSLog(@"the data is not available");
    }
    
}
-(void)viewDidAppear:(BOOL)animated {
}
-(void)getthestep:(double)sender {
    double precentage = totaldist/rewarddist;
    NSLog(@"%f", precentage);
    UIView *progressbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, goalbar.frame.size.width*precentage, 8)];
    progressbar.backgroundColor = [UIColor colorWithRed:0.12 green:0.63 blue:0.95 alpha:0.8];
    progressbar.layer.cornerRadius = 4.0f;
    progressbar.layer.masksToBounds = YES;
    
    [goalbar addSubview:progressbar];
}
-(void)createui {
    mainview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    mainview.backgroundColor = [UIColor whiteColor];
    mainview.showsVerticalScrollIndicator = YES;
    mainview.scrollEnabled = YES;
    mainview.userInteractionEnabled = YES;
    mainview.contentSize = CGSizeMake(curwidth, 2*curheigh/5+3*curwidth+180);
    [self.view addSubview:mainview];
    
}
-(void)membergoal {
    goalbar = [[UIView alloc] initWithFrame:CGRectMake(5, loginpanelview.frame.size.height/2-4, loginpanelview.frame.size.width-10, 8)];
    goalbar.backgroundColor = [UIColor whiteColor];
    goalbar.layer.cornerRadius = 4.0f;
    goalbar.layer.masksToBounds = YES;
    goalbar.layer.borderWidth = 0.5f;
    goalbar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UILabel *welcomesnogen = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, loginpanelview.frame.size.width-10, 20)];
    welcomesnogen.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightLight];
    welcomesnogen.text = @"歡迎";
    
    [loginpanelview addSubview:welcomesnogen];
    [loginpanelview addSubview:goalbar];
}
-(void)readstepHK {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create the query
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:nil
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",error.localizedDescription);
        }
        
        NSDate *endDate = [NSDate date];
        NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                                 value:-7
                                                toDate:endDate
                                               options:0];
        NSLog(@"%@", startDate);
        
        // Plot the daily step counts over the past 7 days
        [results enumerateStatisticsFromDate:startDate
                                      toDate:endDate
                                   withBlock:^(HKStatistics *result, BOOL *stop) {
                                       
                                       HKQuantity *quantity = result.sumQuantity;
                                       if (quantity) {
                                           NSDate *date = result.startDate;
                                           double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                                           NSLog(@"%@: %f", date, value);
                                           NSString *countstep = [NSString stringWithFormat:@"%@", quantity];
                                           totalstep = totalstep + countstep.doubleValue;
                                       }
                                       
                                   }];
        NSLog(@"total step %f", totalstep);
    };
    [healthStore executeQuery:query];
}
-(void)readdist {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 1;
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:[NSDate date]];
    anchorComponents.hour = 0;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    // Create the query
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                           quantitySamplePredicate:nil
                                                                                           options:HKStatisticsOptionCumulativeSum
                                                                                        anchorDate:anchorDate
                                                                                intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",error.localizedDescription);
        }
        
        NSDate *endDate = [NSDate date];
        NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                                 value:-7
                                                toDate:endDate
                                               options:0];
        
        // Plot the daily step counts over the past 7 days
        [results enumerateStatisticsFromDate:startDate
                                      toDate:endDate
                                   withBlock:^(HKStatistics *result, BOOL *stop) {
                                       //NSLog(@"%@", result);
                                       HKQuantity *quantity = result.sumQuantity;
                                       if (quantity) {
                                           NSDate *date = result.startDate;
                                           //double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                                           NSLog(@"%@", quantity);
                                           NSString *countdist = [NSString stringWithFormat:@"%@", quantity];
                                           totaldist = totaldist + countdist.doubleValue;
                                       }
                                       
                                   }];
        NSLog(@"%f", totaldist);
        [self performSelectorOnMainThread:@selector(updatescreen:) withObject:[NSString stringWithFormat:@"%f", totaldist] waitUntilDone:NO];
        
    };
    [healthStore executeQuery:query];
}
-(void)createview {
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh/5)];
    topview.backgroundColor = [UIColor lightGrayColor];
    topview.layer.shadowRadius = 3.0f;
    topview.layer.shadowColor = [UIColor grayColor].CGColor;
    topview.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    topview.layer.shadowOpacity = 0.6f;
    topview.layer.masksToBounds = NO;
    
    //adview banner only for the ad
    
    adbannerview = [[UIView alloc] initWithFrame:CGRectMake(5, curheigh/5+5, curwidth-10, 64)];
    adbannerview.backgroundColor = [UIColor lightGrayColor];
    
    //end of the advirew banner panel
    
    //login panel for the member's only
    
    loginpanelview = [[UIView alloc] initWithFrame:CGRectMake(5, curheigh/5+74, curwidth-10, curheigh/5)];
    loginpanelview.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    loginpanelview.layer.shadowColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    loginpanelview.layer.shadowOpacity = 0.8;
    loginpanelview.layer.shadowOffset = CGSizeMake(0, 3.0);
    loginpanelview.layer.shadowRadius = 3.0f;
    
    //end of the login panel for the memeber's only
    
    //show product view for panel
    
    productpanelview = [[UIView alloc] initWithFrame:CGRectMake(5, 2*curheigh/5+79, curwidth-10, curwidth+40)];
    productpanelview.backgroundColor = [UIColor whiteColor];
    productpanelview.layer.shadowRadius = 3.0f;
    productpanelview.layer.shadowColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    productpanelview.layer.shadowOpacity = 0.8;
    productpanelview.layer.shadowOffset = CGSizeMake(0, 3);
    
    UILabel *productpanellabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, curwidth-20, 25)];
    productpanellabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightSemibold];
    productpanellabel.text = @"熱門新聞";
    productpanellabel.textColor  = [UIColor blackColor];
    
    [productpanelview addSubview:productpanellabel];
    
    //end of the product view of the panel
    //last product vierw panel of showing the highlighted prpducts
    
    productpanelview_2 = [[UIView alloc] initWithFrame:CGRectMake(5, 2*curheigh/5+2*curwidth+129, curwidth-10, curwidth+40)];
    productpanelview_2.backgroundColor = [UIColor whiteColor];
    productpanelview_2.layer.shadowRadius = 3.0f;
    productpanelview_2.layer.shadowColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    productpanelview_2.layer.shadowOpacity = 0.8;
    productpanelview_2.layer.shadowOffset = CGSizeMake(0, 3);
    
    UILabel *productpanel2label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, curwidth-20, 25)];
    productpanel2label.font = [UIFont systemFontOfSize:23 weight:UIFontWeightSemibold];
    productpanel2label.text = @"熱門產品";
    productpanel2label.textColor  = [UIColor blackColor];
    
    [productpanelview_2 addSubview:productpanellabel];
    
    //end of the last product iview panel of showing the heighlightedfd products
    
    //second of the product show panel
    
    productshortpanelview = [[UIView alloc] initWithFrame:CGRectMake(5, 2*curheigh/5+curwidth+124, curwidth-10, curwidth)];
    productshortpanelview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    //end of the second of the procuct show panel
    
    [self membergoal];
    [mainview addSubview:loginpanelview];
    [mainview addSubview:productshortpanelview];
    [mainview addSubview:productpanelview_2];
    [mainview addSubview:productpanelview];
    
    [mainview addSubview:adbannerview];
    [mainview addSubview:topview];
}
-(void)createstepview {
    steplable = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 300, 60)];
    steplable.text = [NSString stringWithFormat:@"%f, %f", totalstep, totaldist];
    [self.view addSubview:steplable];
}
-(IBAction)updatescreen:(id)sender {
    NSLog(@"sender %@", sender);
    
    [self getthestep:[sender doubleValue]];
    [steplable setText:sender];
    [steplable setNeedsDisplay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
