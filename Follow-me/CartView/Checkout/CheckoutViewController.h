//
//  CheckoutViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2018/02/01.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class SuccessViewController;
@class ShipMdViewController;
@class ShipAddViewController;
@class PaymentViewController;
@class CouponViewController;
@class PaymentInputViewController;
@interface CheckoutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    CGFloat curwidth;
    CGFloat curheigh;
    IBOutlet UIBarButtonItem *cancelsbtm;
    IBOutlet UIView *bottomcolmn;
    IBOutlet UIButton *processbutton;
    double subtotal;
    double taxtotal;
    double discounttotal;
    double invtotal;
    NSString *additioninfos;
    NSString *paymenttype;
    NSString *firstname;
    NSString *lastname;
    NSString *companyname;
    NSString *shipstreet;
    NSString *shiptcity;
    NSString *shipstate;
    NSString *shippostal;
    NSString *shipcountry;
    NSString *shipphone;
    NSString *shipemail;
    NSString *shipnote;
    NSString *combinateresult;
    NSString *combinatecost;
    NSString *combinateqty;
    NSUserDefaults *defaults;
    NSObject *obejct;
    NSString *couponcode;
    SuccessViewController *successview;
    ShipAddViewController *shipaddview;
    ShipMdViewController *shipmdview;
    CouponViewController *couponview;
    PaymentViewController *paymentview;
    PaymentInputViewController *paymentinput;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (copy) NSMutableArray *cartproducts;
@property (copy) NSString *cartsubtotal;
@property (copy) NSMutableArray *itemsutotal;
@property (copy) NSMutableArray *cartqty;
@property (copy) NSMutableArray *itemid;
@property (copy) NSMutableArray *itemimg;

@end
