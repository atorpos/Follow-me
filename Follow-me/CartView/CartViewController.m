//
//  CartViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2018/01/29.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "CartViewController.h"
#import <PassKit/PassKit.h>
#import <Stripe/Stripe.h>
#import "SBJson.h"
#import "SuccessViewController.h"
#import "CheckoutViewController.h"

@interface CartViewController () <STPPaymentCardTextFieldDelegate>

@property PKPaymentRequest *payment_request;
@property PKPaymentMethod *payment_method;
@property PKShippingMethod *select_shipping_method;

@end

@implementation CartViewController
@synthesize transcationcomplicated;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    defaults = [NSUserDefaults standardUserDefaults];
    cartsubtotal = [[UILabel alloc] init];
    cartsubtotal.frame = CGRectMake(curwidth/2+5, 5, curwidth/2-15, 25);
    cartsubtotal.textAlignment = NSTextAlignmentRight;
    checkoutbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    applepaybutton = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleWhiteOutline];
    [checkoutbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkoutbutton.backgroundColor = [UIColor colorWithRed:0.41 green:0.85 blue:0.38 alpha:0.8];
    checkoutbutton.layer.borderColor = [UIColor colorWithRed:0.41 green:0.85 blue:0.38 alpha:1].CGColor;
    [[checkoutbutton layer] setBorderWidth:0.5f];
    [[checkoutbutton layer] setCornerRadius:5.0f];
    checkoutbutton.frame = CGRectMake(10, 40, curwidth/2-15, 40);
    [checkoutbutton setTitle:@"結賬" forState:UIControlStateNormal];
    applepaybutton.frame = CGRectMake(curwidth/2+5, 40, curwidth/2-15, 40);
    [applepaybutton setTitle:@"Pay with ApplePay" forState:UIControlStateNormal];
    applepaybutton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    //applepay button
    applepaybutton.enabled = [Stripe deviceSupportsApplePay];
    [applepaybutton addTarget:self action:@selector(applePaytapped) forControlEvents:UIControlEventTouchUpInside];
    [checkoutbutton addTarget:self action:@selector(checkoutprocess:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.87 green:0.39 blue:0.26 alpha:0.6]];
    self.navigationController.navigationBar.topItem.title = @"購物車";
    [self reloaddata];
}
-(void)emptycard {
    UIView *blankview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    blankview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.view addSubview:blankview];
}
-(void)carttable {
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh-140) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tableview];
    
    bottomcolmn = [[UIView alloc] init];
    if (curheigh == 812.000000) {
        bottomcolmn.frame = CGRectMake(0, curheigh-188, curwidth, 120);
    } else {
        bottomcolmn.frame = CGRectMake(0, curheigh-140, curwidth, 120);
    }
    bottomcolmn.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    bottomcolmn.layer.masksToBounds = NO;
    bottomcolmn.layer.shadowOffset = CGSizeMake(0, -2);
    bottomcolmn.layer.shadowOpacity = 0.2;
    bottomcolmn.layer.shadowRadius = 5;
    [self.view addSubview:bottomcolmn];
    
}
-(void)reloaddata {
    cartitem = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"chooseitemid"]];
    cartqty = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"chooseitemno"]];
    cartimgdata = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"choseitemimg"]];
    cartdescription = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"choseitemtitle"]];
    cartprice = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"chooseitemprice"]];
    if([cartprice count] == 0) {
        [tableview removeFromSuperview];
        [bottomcolmn removeFromSuperview];
        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
        [self emptycard];
        NSLog(@"no value");
        shopnow = [[UILabel alloc] initWithFrame:CGRectMake(5, curheigh/2-20, curwidth-10, 40)];
        shopnow.text = @"購物車沒有產品";
        shopnow.textAlignment = NSTextAlignmentCenter;
        shopnow.font = [UIFont systemFontOfSize:17 weight:UIFontWeightUltraLight];
        [self.view addSubview:shopnow];
        
    } else {
        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [[defaults objectForKey:@"chooseitemid"] count]];
        [shopnow removeFromSuperview];
        [self carttable];
        subtotal = 0;
        combinateresult = [cartdescription componentsJoinedByString:@","];
        combinateqty = [cartqty componentsJoinedByString:@","];
        combinatecost=[cartprice componentsJoinedByString:@","];
        combinatedid = [cartitem componentsJoinedByString:@","];
        
        int i;
        for(i=0;i<[cartprice count];i++) {
            subtotal = subtotal + [[cartprice objectAtIndex:i] doubleValue]*[[cartqty objectAtIndex:i] doubleValue];
        }
        bottomsubtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, curwidth-15, 25)];
        bottomsubtitle.text = [NSString stringWithFormat:@"購物車總計："];
        [bottomsubtitle setNeedsDisplay];
        cartsubtotal.text = [NSString stringWithFormat:@"港幣 %.2f", subtotal];
        [bottomcolmn addSubview:bottomsubtitle];
        [bottomcolmn addSubview:cartsubtotal];
        [bottomcolmn addSubview:checkoutbutton];
        [bottomcolmn addSubview:applepaybutton];
        invtotal = subtotal;
    }
}
-(void)applePaytapped {
    paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:@"merchant.pro.followmw.www" country:@"HK" currency:@"HKD"];
    
    paymentRequest.paymentSummaryItems = @[
                                           [PKPaymentSummaryItem summaryItemWithLabel:@"" amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", subtotal] locale:nil]]
                                           ];
    //try with
    NSSet *pkset = [NSSet setWithObjects:PKContactFieldPostalAddress ,PKContactFieldName, PKContactFieldEmailAddress, PKContactFieldPhoneNumber, nil];
    NSLog(@"%@", pkset);
    paymentRequest.requiredShippingContactFields = pkset;
    
    if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
        NSLog(@"Show ap sheet");
        PKPaymentAuthorizationViewController *paymentAuthorizationVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
        paymentAuthorizationVC.delegate = self;
        [self presentViewController:paymentAuthorizationVC animated:YES completion:nil];
    }else {
        return;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cartitem count];
}
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [tableview dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    UILabel *itemname = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 5, curwidth/4*3, 40)];
    itemname.numberOfLines = 2;
    itemname.adjustsFontSizeToFitWidth = YES;
    itemname.text = [NSString stringWithFormat:@"%@", [cartdescription objectAtIndex:indexPath.row]];
    UILabel *itemsubname = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 47, curwidth/4*3, 20)];
    itemsubname.numberOfLines =1;
    itemsubname.font = [UIFont systemFontOfSize:9];
    
    itemsubname.text = [NSString stringWithFormat:@"數量: %@ | 港幣$ %.2f", [cartqty objectAtIndex:indexPath.row], [[cartprice objectAtIndex:indexPath.row] doubleValue]];
    UILabel *itemsubtotal = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/3*2, 90, curwidth/3-5, 30)];
    double itemsubtotalvalue = [[cartprice objectAtIndex:indexPath.row] doubleValue] * [[cartqty objectAtIndex:indexPath.row] doubleValue];
    itemsubtotal.text = [NSString stringWithFormat:@"港幣$ %.2f", itemsubtotalvalue];
    itemsubtotal.adjustsFontSizeToFitWidth = YES;
    itemsubtotal.textAlignment = NSTextAlignmentRight;
    UIImageView *itempicview = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, curwidth/4-4, 100)];
    itempicview.contentMode = UIViewContentModeScaleAspectFill;
    itempicview.clipsToBounds = YES;
    UIImage *showimg = [UIImage imageWithData:[cartimgdata objectAtIndex:indexPath.row]];
    [itempicview setImage:showimg];
    [cell.contentView addSubview:itemsubtotal];
    [cell.contentView addSubview:itemsubname];
    [cell.contentView addSubview:itempicview];
    [cell.contentView addSubview:itemname];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [cartitem removeObjectAtIndex:indexPath.row];
        [cartqty removeObjectAtIndex:indexPath.row];
        [cartimgdata removeObjectAtIndex:indexPath.row];
        [cartdescription removeObjectAtIndex:indexPath.row];
        [cartprice removeObjectAtIndex:indexPath.row];
        [defaults setObject:cartitem forKey:@"chooseitemid"];
        [defaults setObject:cartqty forKey:@"chooseitemno"];
        [defaults setObject:cartimgdata forKey:@"choseitemimg"];
        [defaults setObject:cartdescription forKey:@"choseitemtitle"];
        [defaults setObject:cartprice forKey:@"chooseitemprice"];
        [self reloaddata];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableview deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark PKPaymentAuthorizationViewControllerDelegate
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSLog(@"start authoride");
    
    [[STPAPIClient sharedClient] createTokenWithPayment:payment completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
        NSLog(@"%@", error);
        if(token) {
            NSLog(@"yes token %@", token);
            NSLog(@"token %@", payment.shippingContact.postalAddress);
            NSString *stripeAPI = @"sk_live_l2DDUGECfaw9i4hTmZ36ydyQ"; //testapi sk_test_lDL5DW1w3bn10dusvalBBz4D, public api sk_live_l2DDUGECfaw9i4hTmZ36ydyQ
            NSString *float2 = [NSString stringWithFormat:@"%.2f", invtotal];
            NSString *chargevalue = [float2 stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *poststring = [NSString stringWithFormat:@"stripeToken=%@&paymentamount=%@&paymentcurrency=hkd&stripeAPI=%@&email=%@&pnumber=%@&shipstreet=%@&shipcity=%@&shipstate=%@&shippostal=%@&shipcountry=%@&firstname=%@&lastname=%@&transdetail=%@&cartdisc=%.2f&combincost=%@&combinqty=%@",token, chargevalue, stripeAPI, payment.shippingContact.emailAddress, [payment.shippingContact.phoneNumber valueForKey:@"digits"], payment.shippingContact.postalAddress.street,payment.shippingContact.postalAddress.city,payment.shippingContact.postalAddress.state,payment.shippingContact.postalAddress.postalCode,payment.shippingContact.postalAddress.country,payment.shippingContact.name.givenName,payment.shippingContact.name.familyName,combinatedid,discount,combinatecost,combinateqty];
            
            NSData *postData = [poststring dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[poststring length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:[NSURL URLWithString:@"https://www.follow-me.pro/be_charge.php"]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if(response &&! error) {
                    NSString *responseString = [[NSString alloc] initWithData: data  encoding: NSUTF8StringEncoding];
                    NSLog(@"成功: %@", responseString);
                    SBJsonParser *parsejson = [SBJsonParser new];
                    NSDictionary *jsonData = (NSDictionary *) [parsejson objectWithString:responseString error:nil];
                    NSLog(@"test json %@", jsonData);
                    NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
                    if (success == 1) {
                        NSLog(@"Transition has been approved");
                        completion(PKPaymentAuthorizationStatusSuccess);
                        NSString *message = [jsonData objectForKey:@"message"];
                        [self performSelectorOnMainThread:@selector(sentconfirm:) withObject:message waitUntilDone:YES];
                        //debug the display error....
                        //dispatch_async(dispatch_get_main_queue(), ^{
                        //    [self.popupController customdismissPopupControllerAnimated:NO];
                        //    finishupview = [self.storyboard instantiateViewControllerWithIdentifier:@"finishupview"];
                        //    //NSString *typeofdoc = @"PT";
                        //    [self.navigationController pushViewController:finishupview animated:NO];
                        //});
                    } else {
                        NSLog(@"Transition has been rejected");
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            alertview = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, curwidth, 40)];
                            alertview.backgroundColor = [UIColor colorWithRed:0.96 green:0.28 blue:0.28 alpha:0.6];
                            alertview.text = @"Transition Error";
                            alertview.textColor = [UIColor whiteColor];
                            alertview.textAlignment = NSTextAlignmentCenter;
                            alertview.font = [UIFont systemFontOfSize:13];
                            [self.view addSubview:alertview];
                            [self performSelector:@selector(popuphide) withObject:self afterDelay:4];
                            completion(PKPaymentAuthorizationStatusFailure);
                        });
                        
                    }
                } else {
                    NSLog(@"Fail: %@", error);
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        alertview = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, curwidth, 40)];
                        alertview.backgroundColor = [UIColor colorWithRed:0.96 green:0.28 blue:0.28 alpha:0.6];
                        alertview.text = @"Transition Error";
                        alertview.textColor = [UIColor whiteColor];
                        alertview.textAlignment = NSTextAlignmentCenter;
                        alertview.font = [UIFont systemFontOfSize:13];
                        [self.view addSubview:alertview];
                        [self performSelector:@selector(popuphide) withObject:self afterDelay:4];
                        completion(PKPaymentAuthorizationStatusFailure);
                    });
                }
                
            }];
            [task resume];
            
        }else {
            NSLog(@"Error creating token: %@", error.localizedDescription);
            completion(PKPaymentAuthorizationStatusFailure);
        }
    }];
}
-(void)popuphide {
    alertview.hidden = YES;
}
-(void)paymentAuthorizationController:(PKPaymentAuthorizationController *)controller didSelectShippingContact:(PKContact *)contact handler:(void (^)(PKPaymentRequestShippingContactUpdate * _Nonnull))completion {
    NSLog(@"%@", contact.postalAddress);
}

- (void)paymentAuthorizationControllerDidFinish:(nonnull PKPaymentAuthorizationController *)controller {
    NSLog(@"Finished controller");
}


- (void)paymentAuthorizationViewControllerDidFinish:(nonnull PKPaymentAuthorizationViewController *)controller {
    NSLog(@"finished");
    [self dismissViewControllerAnimated:YES completion:nil];
    if([transcationcomplicated isEqualToString:@"complicated"]) {
        [self presentViewController:successview animated:YES completion:nil];
    }
}


- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    NSLog(@"encode");
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    NSLog(@"trailcollect");
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    NSLog(@"changesize");
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(curwidth/2, curheigh/2);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    NSLog(@"systemlayout");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"viewwilltransition");
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"willtransitiontotrait");
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    NSLog(@"didupdatefocus");
}

- (void)setNeedsFocusUpdate {
    NSLog(@"needfoucs");
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}

- (void)updateFocusIfNeeded {
    NSLog(@"updatefocus");
}

-(IBAction)sentconfirm:(id)sender {
    NSLog(@"confirmed");
    transcationcomplicated = @"complicated";
    successview = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessView"];
    successview.responsevalue = [NSString stringWithFormat:@"%.2f",invtotal];
    successview.responsestring = sender;
    
    //[self.navigationController popToViewController:successview animated:YES];
}
-(IBAction)checkoutprocess:(id)sender {
    NSLog(@"checkout process");
    checkview = [self.storyboard instantiateViewControllerWithIdentifier:@"checkoutview"];
    checkview.cartsubtotal = [NSString stringWithFormat:@"%.2f", subtotal];
    checkview.cartproducts = cartdescription;
    checkview.itemsutotal = cartprice;
    checkview.cartqty = cartqty;
    checkview.itemid = cartitem;
    checkview.itemimg = cartimgdata;
    [self.navigationController pushViewController:checkview animated:YES];
}

@end
