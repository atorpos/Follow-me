//
//  FirstViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <HealthKit/HealthKit.h>
#import "serviceurl.h"
#import "UIImageView+WebCache.h"

@class ProductDetailViewController;
@class NewsDetailViewController;
@class LoginViewController;
@class WebViewController;
@interface FirstViewController : UIViewController {
    NSUserDefaults *standardUsers;
    CGFloat curwidth;
    CGFloat curheigh;
    double rewardstep;
    double rewarddist;
    //HKHealthStore *healthStore;
    double totalstep;
    double totaldist;
    UILabel *steplable;
    UIScrollView *mainview;
    UIView *topview;
    UIView *adbannerview;
    UIView *loginpanelview;
    UIView *productpanelview;
    UIView *productpanelview_2;
    UIView *productshortpanelview;
    UIView *goalbar;
    UILabel *currentstep;
    NSArray *newstitle;
    NSArray *newsdate;
    NSArray *newsimg;
    NSArray *newsauthor;
    NSArray *newscontents;
    NSArray *storeproductname;
    NSArray *storeproductprice;
    NSArray *storeproductcat;
    NSArray *storeproductimg;
    NSArray *storeproductexcep;
    NSArray *newsid;
    NSArray *productid;
    NSArray *featproductname;
    NSArray *featproductprice;
    NSArray *featproductcat;
    NSArray *featproductimg;
    NSArray *featproductid;
    NSArray *featproductexcep;
    ProductDetailViewController *productview;
    NewsDetailViewController *newsview;
    LoginViewController *loginview;
    WebViewController *webview;
    UIView *bottomgoalview;
    NSString *pagetitle;
    NSString *welcometitle;
}

@property (nonatomic, retain) IBOutlet UIScrollView *pagescrollviewsecond;
@property (nonatomic, retain) IBOutlet UIPageControl *pagecontrolsecond;

@end

