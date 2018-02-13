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
#import "NewsDetailViewController.h"
#import "ProductDetailViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"

@interface FirstViewController () <STPPaymentCardTextFieldDelegate>

@property (nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic) UIButton *submitButton;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    standardUsers = [NSUserDefaults standardUserDefaults];
    if ([[standardUsers objectForKey:@"chooseitemid"] count] == 0) {
        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
    } else {
        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [[standardUsers objectForKey:@"chooseitemid"] count]];
    }
    NSLog(@"%@", [standardUsers objectForKey:@"username"]);
    
    rewarddist = 150000.00;
    rewardstep = 150000.00;
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    newstitle = [[NSArray alloc] init];
    newsdate = [[NSArray alloc] init];
    newsimg = [[NSArray alloc] init];
    newstitle = [[NSArray alloc] init];
    newsdate = [[NSArray alloc] init];
    newsimg = [[NSArray alloc] init];
    newsauthor = [[NSArray alloc] init];
    storeproductname = [[NSArray alloc] init];
    storeproductprice = [[NSArray alloc] init];
    storeproductcat = [[NSArray alloc] init];
    storeproductimg = [[NSArray alloc] init];
    newsid = [[NSArray alloc] init];
    productid = [[NSArray alloc] init];
    newscontents = [[NSArray alloc] init];
    storeproductexcep = [[NSArray alloc] init];
    featproductid = [[NSArray alloc] init];
    featproductcat = [[NSArray alloc] init];
    featproductimg = [[NSArray alloc] init];
    featproductname = [[NSArray alloc] init];
    featproductprice = [[NSArray alloc] init];
    featproductexcep = [[NSArray alloc] init];
    NSLog(@"%f", curheigh);
    [self createui];
    
    self.navigationController.navigationBar.topItem.title = @"快樂猫";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *checkfile = [documentsDirectory stringByAppendingPathComponent:@"initialjson.json"];
    
    NSData *favdata = [NSData dataWithContentsOfFile:checkfile];
    [self performSelectorOnMainThread:@selector(fetchlink:) withObject:favdata waitUntilDone:NO];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.47 green:0.71 blue:0.23 alpha:0.5]];
    [self createview];
}
-(void)viewDidAppear:(BOOL)animated {
    //NSLog(@"cart %@", [standardUsers objectForKey:@"choseitemimg"]);
    NSURL *medianewurl = [NSURL URLWithString:HEADER_MEDIA_URL];
    NSURL *shopurl = [NSURL URLWithString:HEADER_SHOP_URL];
    NSURL *feaurl = [NSURL URLWithString:HEADER_FEAT_URL];
    NSData *mediadata = [NSData dataWithContentsOfURL:medianewurl];
    NSData *shopdata = [NSData dataWithContentsOfURL:shopurl];
    NSData *feadata = [NSData dataWithContentsOfURL:feaurl];
    [self performSelectorOnMainThread:@selector(fetchnews:) withObject:mediadata waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(fetchshop:) withObject:shopdata waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(fetchfav:) withObject:feadata waitUntilDone:NO];
    totaldist = 0;
    totalstep = 0;
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
                                               if(success == YES && [standardUsers objectForKey:@"username"])
                                               {
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
-(void)fetchlink:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"%@", json);
}
-(void)fetchnews:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    newstitle = [json valueForKeyPath:@"post_title"];
    newsdate = [json valueForKeyPath:@"post_date"];
    newsimg = [json valueForKeyPath:@"imgurl"];
    newsauthor = [json valueForKeyPath:@"post_author"];
    newsid = [json valueForKeyPath:@"ID"];
    newscontents = [json valueForKeyPath:@"post_content"];
    [self newspanelview];
}
-(void)fetchfav:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    featproductname = [json valueForKeyPath:@"post_title"];
    featproductprice = [[json valueForKeyPath:@"meta"] valueForKeyPath:@"_regular_price"];
    featproductcat = [[json valueForKeyPath:@"meta"] valueForKeyPath:@"_stock_status"];
    featproductimg = [json valueForKeyPath:@"imgurl"];
    featproductid = [json valueForKeyPath:@"ID"];
    featproductexcep = [json valueForKeyPath:@"post_excerpt"];
    NSLog(@"feature %@", featproductname);
    [self cr_productpanelview];
}
-(void)fetchshop:(NSData *) responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    storeproductname = [json valueForKeyPath:@"post_title"];
    storeproductprice = [[json valueForKeyPath:@"meta"] valueForKeyPath:@"_regular_price"];
    storeproductcat = [[json valueForKeyPath:@"meta"] valueForKeyPath:@"_stock_status"];
    storeproductimg = [json valueForKeyPath:@"imgurl"];
    productid = [json valueForKeyPath:@"ID"];
    storeproductexcep = [json valueForKeyPath:@"post_excerpt"];
    NSLog(@"store %@", storeproductname);
    [self pl_productpanelview];
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
    welcomesnogen.text = [NSString stringWithFormat:@"歡迎, %@", [standardUsers objectForKey:@"display_name"]];
    
    
    UILabel *totalsteplab = [[UILabel alloc] initWithFrame:CGRectMake(goalbar.frame.size.width/2, loginpanelview.frame.size.height/2-25, goalbar.frame.size.width/2-5, 19)];
    totalsteplab.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightUltraLight];
    totalsteplab.text = @"每一萬步送港幣1元!";
    totalsteplab.textAlignment = NSTextAlignmentRight;
    
    currentstep = [[UILabel alloc] initWithFrame:CGRectMake(5, loginpanelview.frame.size.height/2-25, goalbar.frame.size.width/2-5, 19)];
    currentstep.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightUltraLight];
    currentstep.textAlignment= NSTextAlignmentLeft;
    [currentstep setText:@"Loading..."];
    
    [loginpanelview addSubview:totalsteplab];
    [loginpanelview addSubview:currentstep];
    [loginpanelview addSubview:welcomesnogen];
    [loginpanelview addSubview:goalbar];
}
-(void)memberlogin {
    [bottomgoalview removeFromSuperview];
    UILabel *welcomesnogen = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, loginpanelview.frame.size.width-10, 20)];
    welcomesnogen.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightLight];
    welcomesnogen.text = @"歡迎！登入穫取更多優惠！";
    
    UIButton *loginbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginbutton.frame = CGRectMake(40, 40, loginpanelview.frame.size.width-80,40);
    loginbutton.backgroundColor = [UIColor colorWithRed:0.33 green:0.70 blue:0.29 alpha:0.8];
    [loginbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbutton.layer.cornerRadius = 20.0;
    
    [loginbutton setTitle:@"登入" forState:UIControlStateNormal];
    loginbutton.tag = 0;
    [loginbutton addTarget:self action:@selector(WMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    registbutton.frame = CGRectMake(10, 90, loginpanelview.frame.size.width-10, 20);
    [registbutton setTitle:@"開設賬戶" forState:UIControlStateNormal];
    [registbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    registbutton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    [registbutton addTarget:self action:@selector(bMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginpanelview addSubview:registbutton];
    [loginpanelview addSubview:loginbutton];
    [loginpanelview addSubview:welcomesnogen];
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
        if (totalstep != 0) {
            [self performSelectorOnMainThread:@selector(updatestep:) withObject:[NSString stringWithFormat:@"現在運動了 %.0f 步", totalstep] waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(adddicount) withObject:nil waitUntilDone:NO];
        }
        
    };
    [healthStore executeQuery:query];
}

-(IBAction)updatestep:(id)sender {
    [currentstep setText:sender];
}
-(void)adddicount {
    bottomgoalview = [[UIView alloc] initWithFrame:CGRectMake(0, loginpanelview.frame.size.height-40, loginpanelview.frame.size.width, 40)];
    bottomgoalview.backgroundColor = [UIColor colorWithRed:0.85 green:0.38 blue:0.33 alpha:0.8];
    
    UILabel *receivediscount = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bottomgoalview.frame.size.width, 19)];
    receivediscount.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightThin];
    receivediscount.text = [NSString stringWithFormat:@"現在有港幣 %.0f.00元的節扣", totalstep/10000];
    [standardUsers setObject:[NSString stringWithFormat:@"%.0f", totalstep/10000] forKey:@"stepdiscount"];
    receivediscount.textAlignment = NSTextAlignmentCenter;
    receivediscount.textColor = [UIColor whiteColor];
    [bottomgoalview addSubview:receivediscount];
    [loginpanelview addSubview:bottomgoalview];
}

-(IBAction)NMethod:(id)sender {
    NSLog(@"click news detail button");
    UIButton *passvalue = (UIButton *)sender;
    newsview = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailView"];
    newsview.detailtitle = newstitle[passvalue.tag];
    newsview.productid = newsid[passvalue.tag];
    newsview.newscontents = newscontents[passvalue.tag];
    [self.navigationController pushViewController:newsview animated:YES];
}
-(IBAction)WMethod:(id)sender {
    NSLog(@"webmethod");
    loginview = [self.storyboard instantiateViewControllerWithIdentifier:@"loginview"];
    [self.navigationController presentViewController:loginview animated:YES completion:nil];
}

-(IBAction)PMethod:(id)sender {
    NSLog(@"click product detail button");
    UIButton *passvalue = (UIButton *)sender;
    productview = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    productview.detailtitle = featproductname[passvalue.tag];
    productview.postid = featproductid[passvalue.tag];
    productview.postcontent = featproductexcep[passvalue.tag];
    [self.navigationController pushViewController:productview animated:YES];
}
-(IBAction)aMethod:(id)sender {
    UIButton *passvalue = (UIButton *)sender;
    productview = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    productview.detailtitle = storeproductname[passvalue.tag];
    productview.postid = productid[passvalue.tag];
    productview.postcontent = storeproductexcep[passvalue.tag];
    [self.navigationController pushViewController:productview animated:YES];
}
-(IBAction)bMethod:(id)sender {
    //mainController = (ViewController *)self.parentViewController;
    webview = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    webview.weblinkstring = @"https://www.follow-me.pro/weblogin.php";
    [self presentViewController:webview animated:NO completion:nil];
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
    
    UIImageView *welcomeview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height)];
    UIImage *welcomeimage = [UIImage imageNamed:@"welcome.jpg"];
    welcomeview.contentMode = UIViewContentModeScaleAspectFill;
    [welcomeview setImage:welcomeimage];
    
    [topview addSubview:welcomeview];
    
    //adview banner only for the ad
    
    adbannerview = [[UIView alloc] initWithFrame:CGRectMake(5, curheigh/5+5, curwidth-10, 64)];
    adbannerview.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *adimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, adbannerview.frame.size.width, adbannerview.frame.size.height)];
    UIImage *adimg = [UIImage imageNamed:@"ad.jpg"];
    adimgview.contentMode = UIViewContentModeScaleAspectFill;
    [adimgview setImage:adimg];
    [adbannerview addSubview:adimgview];
    
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
    
    UIView *toptitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, productpanelview.frame.size.width, 35)];
    toptitle.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    toptitle.layer.zPosition = 100;
    
    UILabel *productpanellabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, curwidth-20, 25)];
    productpanellabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightSemibold];
    productpanellabel.text = @"熱門新聞";
    productpanellabel.textColor  = [UIColor blackColor];
    productpanellabel.backgroundColor = [UIColor clearColor];
    productpanellabel.layer.zPosition = 101;
    
    [toptitle addSubview:productpanellabel];
    [productpanelview addSubview:toptitle];
    
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
    productpanel2label.layer.zPosition = 101;
    
    [productpanelview_2 addSubview:productpanel2label];
    
    //end of the last product iview panel of showing the heighlightedfd products
    
    //second of the product show panel
    
    productshortpanelview = [[UIView alloc] initWithFrame:CGRectMake(5, 2*curheigh/5+curwidth+124, curwidth-10, curwidth)];
    productshortpanelview.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //end of the second of the procuct show panel
    if (![standardUsers objectForKey:@"username"]) {
        [self memberlogin];
    } else {
        [self membergoal];
    }
    
    [mainview addSubview:loginpanelview];
    [mainview addSubview:productshortpanelview];
    [mainview addSubview:productpanelview_2];
    [mainview addSubview:productpanelview];
    
    [mainview addSubview:adbannerview];
    [mainview addSubview:topview];
}
-(void)newspanelview {
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, productpanelview.frame.size.height-53, productpanelview.frame.size.width, 53)];
    bottomview.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    UILabel *newtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, productpanelview.frame.size.width-20, 25)];
    newtitle.text = newstitle[0];
    newtitle.textAlignment = NSTextAlignmentLeft;
    newtitle.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
    [newtitle adjustsFontSizeToFitWidth];
    newtitle.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, productpanelview.frame.size.width, 17)];
    subtitle.text = [NSString stringWithFormat:@"日期: %@", newsdate[0]];
    subtitle.textAlignment = NSTextAlignmentLeft;
    subtitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    [subtitle adjustsFontSizeToFitWidth];
    subtitle.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    UIImageView *newsimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, productpanelview.frame.size.width, productpanelview.frame.size.height)];
    [newsimageview setClipsToBounds:YES];
    
    newsimageview.contentMode = UIViewContentModeScaleAspectFill;
    [newsimageview sd_setImageWithURL:[NSURL URLWithString:newsimg[0]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UIButton *clickbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clickbutton.frame = CGRectMake(0, 0, productpanelview.frame.size.width, productpanelview.frame.size.height);
    [clickbutton setTitle:@"" forState:UIControlStateNormal];
    clickbutton.tag = 0;
    [clickbutton addTarget:self action:@selector(NMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [productpanelview addSubview:newsimageview];
    [productpanelview addSubview:clickbutton];
    [bottomview addSubview:newtitle];
    [bottomview addSubview:subtitle];
    [productpanelview addSubview:bottomview];
}
-(void)cr_productpanelview {
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, productpanelview_2.frame.size.height-53, productpanelview_2.frame.size.width, 53)];
    bottomview.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    UILabel *newtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, productpanelview_2.frame.size.width-20, 25)];
    newtitle.text = featproductname[0];
    newtitle.textAlignment = NSTextAlignmentLeft;
    newtitle.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
    [newtitle adjustsFontSizeToFitWidth];
    newtitle.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, productpanelview_2.frame.size.width, 17)];
    subtitle.text = [NSString stringWithFormat:@"售價：HKD %@.00", featproductprice[0]];
    subtitle.textAlignment = NSTextAlignmentLeft;
    subtitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    [subtitle adjustsFontSizeToFitWidth];
    subtitle.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    UIImageView *newsimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, productpanelview_2.frame.size.width, productpanelview_2.frame.size.height)];
    [newsimageview setClipsToBounds:YES];
    
    newsimageview.contentMode = UIViewContentModeScaleAspectFill;
    
    [newsimageview sd_setImageWithURL:[NSURL URLWithString:featproductimg[0]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UIButton *clickbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clickbutton.frame = CGRectMake(0, 0, productpanelview_2.frame.size.width, productpanelview_2.frame.size.height);
    [clickbutton setTitle:@"" forState:UIControlStateNormal];
    clickbutton.tag = 0;
    [clickbutton addTarget:self action:@selector(PMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [productpanelview_2 addSubview:newsimageview];
    [productpanelview_2 addSubview:clickbutton];
    [bottomview addSubview:newtitle];
    [bottomview addSubview:subtitle];
    [productpanelview_2 addSubview:bottomview];
}
-(void)pl_productpanelview {
    UILabel *productpanellabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, curwidth-20, 25)];
    productpanellabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightSemibold];
    productpanellabel.text = @"最新產品";
    productpanellabel.textColor  = [UIColor blackColor];
    productpanellabel.backgroundColor = [UIColor clearColor];
    productpanellabel.layer.zPosition = 101;
    
    UIButton *firstbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstbutton.frame = CGRectMake(0, 30, productshortpanelview.frame.size.width, (productshortpanelview.frame.size.height-30)/3);
    firstbutton.tag = 0;
    [firstbutton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *secondbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondbutton.frame = CGRectMake(0, (productshortpanelview.frame.size.height-30)/3+30, productshortpanelview.frame.size.width, (productshortpanelview.frame.size.height-30)/3);
    secondbutton.tag = 1;
    [secondbutton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *thirdbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdbutton.frame = CGRectMake(0, 2*(productshortpanelview.frame.size.height-30)/3+30, productshortpanelview.frame.size.width, (productshortpanelview.frame.size.height-30)/3);
    thirdbutton.tag = 2;
    [thirdbutton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *firstimgview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, firstbutton.frame.size.height-10, firstbutton.frame.size.height-10)];
    [firstimgview sd_setImageWithURL:[NSURL URLWithString:storeproductimg[0]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    UIImageView *secondimgview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, secondbutton.frame.size.height-10, secondbutton.frame.size.height-10)];
    [secondimgview sd_setImageWithURL:[NSURL URLWithString:storeproductimg[1]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    UIImageView *thirdimgview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, thirdbutton.frame.size.height-10, thirdbutton.frame.size.height-10)];
    [thirdimgview sd_setImageWithURL:[NSURL URLWithString:storeproductimg[2]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    CGFloat viewwidth;
    viewwidth = productshortpanelview.frame.size.width - firstbutton.frame.size.height;
    
    UILabel *firstlabel = [[UILabel alloc] initWithFrame:CGRectMake(firstbutton.frame.size.height, 5, viewwidth, 52)];
    firstlabel.text = [NSString stringWithFormat:@"%@", storeproductname[0]];
    firstlabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBlack];
    firstlabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstlabel.numberOfLines = 2;
    firstlabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *secondlaber = [[UILabel alloc] initWithFrame:CGRectMake(secondbutton.frame.size.height, 5, viewwidth, 52)];
    secondlaber.text = [NSString stringWithFormat:@"%@", storeproductname[1]];
    secondlaber.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBlack];
    secondlaber.lineBreakMode = NSLineBreakByWordWrapping;
    secondlaber.numberOfLines = 2;
    secondlaber.textAlignment = NSTextAlignmentLeft;
    
    UILabel *thirdlaber = [[UILabel alloc] initWithFrame:CGRectMake(thirdbutton.frame.size.height, 5, viewwidth, 52)];
    thirdlaber.text = [NSString stringWithFormat:@"%@", storeproductname[2]];
    thirdlaber.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBlack];
    thirdlaber.lineBreakMode = NSLineBreakByWordWrapping;
    thirdlaber.numberOfLines = 2;
    thirdlaber.textAlignment = NSTextAlignmentLeft;
    
    UILabel *firstprice = [[UILabel alloc] initWithFrame:CGRectMake(firstbutton.frame.size.height, 60, viewwidth, 21)];
    firstprice.text = [NSString stringWithFormat:@"港幣：%@", storeproductprice[0]];
    firstprice.font = [UIFont systemFontOfSize:19 weight:UIFontWeightThin];
    
    UILabel *secondprice = [[UILabel alloc] initWithFrame:CGRectMake(secondbutton.frame.size.height, 60, viewwidth, 21)];
    secondprice.text = [NSString stringWithFormat:@"港幣：%@", storeproductprice[1]];
    secondprice.font = [UIFont systemFontOfSize:19 weight:UIFontWeightThin];
    
    UILabel *thirdprice = [[UILabel alloc] initWithFrame:CGRectMake(thirdbutton.frame.size.height, 60, viewwidth, 21)];
    thirdprice.text = [NSString stringWithFormat:@"港幣：%@", storeproductprice[2]];
    thirdprice.font = [UIFont systemFontOfSize:19 weight:UIFontWeightThin];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0, firstbutton.frame.size.height-1, productshortpanelview.frame.size.width, 1.0);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    CALayer *bottomBorder_1 = [CALayer layer];
    bottomBorder_1.frame = CGRectMake(0.0, firstbutton.frame.size.height-1, productshortpanelview.frame.size.width, 1.0);
    bottomBorder_1.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    CALayer *bottomBorder_2 = [CALayer layer];
    bottomBorder_2.frame = CGRectMake(0.0, firstbutton.frame.size.height-1, productshortpanelview.frame.size.width, 1.0);
    bottomBorder_2.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [productshortpanelview addSubview:productpanellabel];
    [firstbutton addSubview:firstimgview];
    [secondbutton addSubview:secondimgview];
    [thirdbutton addSubview:thirdimgview];
    [firstbutton.layer addSublayer:bottomBorder_1];
    [secondbutton.layer addSublayer:bottomBorder];
    [thirdbutton.layer addSublayer:bottomBorder_2];
    [firstbutton addSubview:firstlabel];
    [secondbutton addSubview:secondlaber];
    [thirdbutton addSubview:thirdlaber];
    [firstbutton addSubview:firstprice];
    [secondbutton addSubview:secondprice];
    [thirdbutton addSubview:thirdprice];
    [productshortpanelview addSubview:firstbutton];
    [productshortpanelview addSubview:secondbutton];
    [productshortpanelview addSubview:thirdbutton];
}
-(void)createstepview {
    steplable = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 300, 60)];
    steplable.text = [NSString stringWithFormat:@"%f, %f", totalstep, totaldist];
    [standardUsers setObject:[NSString stringWithFormat:@"%.0f", totalstep] forKey:@"totalstep"];
    
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
