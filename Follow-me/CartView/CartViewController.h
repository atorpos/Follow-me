//
//  CartViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2018/01/29.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@class SuccessViewController, CheckoutViewController;
@interface CartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PKPaymentAuthorizationViewControllerDelegate, PKPaymentAuthorizationControllerDelegate> {
    UITableView *tableview;
    CGFloat curwidth;
    CGFloat curheigh;
    NSUserDefaults *defaults;
    PKPaymentRequest *paymentRequest;
    IBOutlet UIBarButtonItem *cancelsbtm;
    IBOutlet UIView *bottomcolmn;
    IBOutlet UIButton *checkoutbutton;
    IBOutlet UIButton *applepaybutton;
    double subtotal;
    double discount;
    double invtotal;
    IBOutlet UILabel *cartsubtotal;
    NSString *combinateresult;
    NSString *combinateqty;
    NSString *combinatecost;
    NSString *combinatedid;
    IBOutlet UILabel *alertview;
    IBOutlet UILabel *bottomsubtitle;
    IBOutlet UILabel *shopnow;
    NSMutableArray *cartitem;
    NSMutableArray *cartqty;
    NSMutableArray *cartimgdata;
    NSMutableArray *cartdescription;
    NSMutableArray *cartprice;
    SuccessViewController *successview;
    CheckoutViewController *checkview;
    
}
@property (nonatomic, retain) NSString *transcationcomplicated;
@end
