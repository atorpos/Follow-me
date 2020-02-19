//
//  PaymentInputViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuccessViewController;
@interface PaymentInputViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    CGFloat curwidth;
    CGFloat curheigh;
    SuccessViewController *successview;
}


@property (copy) NSString *totalamount;
@property (copy) NSString *typeofpayment;
@property (copy) NSString *subtotalamount;
@property (copy) NSString *shippingamount;
@property (copy) NSString *discountamount;
@property (copy) NSString *firstname;
@property (copy) NSString *paymenttype;
@property (copy) NSString *lastname;
@property (copy) NSString *companyname;
@property (copy) NSString *shipstreet;
@property (copy) NSString *shiptcity;
@property (copy) NSString *shipstate;
@property (copy) NSString *shippostal;
@property (copy) NSString *shipcountry;
@property (copy) NSString *shipphone;
@property (copy) NSString *shipemail;
@property (copy) NSString *shipnote;
@property (copy) NSString *combinateresult;
@property (copy) NSString *combinatecost;
@property (copy) NSString *combinateqty;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

