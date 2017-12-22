//
//  FirstViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface FirstViewController : UIViewController {
    NSUserDefaults *standardUsers;
    CGFloat curwidth;
    CGFloat curheigh;
    double rewardstep;
    double rewarddist;
    HKHealthStore *healthStore;
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
}

@end

