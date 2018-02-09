//
//  CouponViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    CGFloat curwidth;
    CGFloat curheigh;
    IBOutlet UIButton *couponbutton;
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (retain, nonatomic) IBOutlet UITextField *couponfield;

@end
