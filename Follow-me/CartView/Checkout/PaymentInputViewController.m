//
//  PaymentInputViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "PaymentInputViewController.h"
#import <Stripe/Stripe.h>
#import "SBJson.h"
#import "SuccessViewController.h"

@interface PaymentInputViewController ()<STPPaymentCardTextFieldDelegate>

@property (nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic) UIButton *submitButton;

@end

@implementation PaymentInputViewController
@synthesize totalamount, typeofpayment, tableview, subtotalamount, discountamount, shippingamount, firstname, lastname, companyname, shipnote, shipemail, shipphone, shipcountry, shippostal, shipstate, shiptcity, shipstreet, combinateqty, combinatecost, combinateresult;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"Process Checkout"];
    NSLog(@"%@, %@ %@, %@, %@", totalamount, typeofpayment, subtotalamount, shippingamount, discountamount);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDidHide:)];
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    [self.view addGestureRecognizer:tap];
    
    
    [self.view addSubview:tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int nuofrow;
    switch (section) {
        case 0:
            nuofrow = 4;
            break;
        case 1:
            nuofrow = 2;
        default:
            nuofrow = 2;
            break;
    }
    return nuofrow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowheight;
    switch (indexPath.section) {
        case 0:
            rowheight = 40;
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    rowheight = 50;
                    break;
                case 1:
                    rowheight = 50;
                    break;
                default:
                    rowheight = 50;
                    break;
            }
        }
        default:
            rowheight = 50;
            break;
    }
    return rowheight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleofgroup;
    switch (section) {
        case 0:
            titleofgroup = @"Invoice Summary";
            break;
        case 1:
            titleofgroup = [NSString stringWithFormat:@"Payment - Credit card"];
            break;
        default:
            break;
    }
    return titleofgroup;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UILabel *invoicetotallabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, curwidth/2-20, 15)];
                    invoicetotallabel.text = @"Subtotal:";
                    invoicetotallabel.textAlignment = NSTextAlignmentLeft;
                    invoicetotallabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
                    
                    UILabel *invoicetotal = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/2+5, 12, curwidth/2-10, 16)];
                    invoicetotal.text = [NSString stringWithFormat:@"港幣 %.2f",[subtotalamount doubleValue]];
                    invoicetotal.textAlignment = NSTextAlignmentRight;
                    invoicetotal.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                    invoicetotal.adjustsFontSizeToFitWidth = YES;
                    [cell.contentView addSubview:invoicetotallabel];
                    [cell.contentView addSubview:invoicetotal];
                }
                    break;
                case 1:
                {
                    UILabel *invoicetotallabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, curwidth/2-20, 15)];
                    invoicetotallabel.text = @"Shipping:";
                    invoicetotallabel.textAlignment = NSTextAlignmentLeft;
                    invoicetotallabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
                    
                    UILabel *invoicetotal = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/2+5, 12, curwidth/2-10, 16)];
                    invoicetotal.text = [NSString stringWithFormat:@"港幣 %.2f",[shippingamount doubleValue]];
                    invoicetotal.textAlignment = NSTextAlignmentRight;
                    invoicetotal.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                    invoicetotal.numberOfLines = 1;
                    invoicetotal.adjustsFontSizeToFitWidth = YES;
                    
                    [cell.contentView addSubview:invoicetotallabel];
                    [cell.contentView addSubview:invoicetotal];
                    
                }
                    break;
                case 2:
                {
                    UILabel *invoicetotallabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, curwidth/2-20, 15)];
                    invoicetotallabel.text = @"Discount:";
                    invoicetotallabel.textAlignment = NSTextAlignmentLeft;
                    invoicetotallabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
                    
                    UILabel *invoicetotal = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/2+5, 10, curwidth/2-10, 19)];
                    invoicetotal.text = [NSString stringWithFormat:@"港幣 %.2f",[discountamount doubleValue]];
                    invoicetotal.textAlignment = NSTextAlignmentRight;
                    invoicetotal.textColor = [UIColor redColor];
                    invoicetotal.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                    invoicetotal.numberOfLines = 1;
                    invoicetotal.adjustsFontSizeToFitWidth = YES;
                    
                    [cell.contentView addSubview:invoicetotal];
                    [cell.contentView addSubview:invoicetotallabel];
                }
                    break;
                case 3:
                {
                    UILabel *invoicetotallabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, curwidth/2-20, 15)];
                    invoicetotallabel.text = @"Total:";
                    invoicetotallabel.textAlignment = NSTextAlignmentLeft;
                    invoicetotallabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
                    
                    UILabel *invoicetotal = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/2+5, 10, curwidth/2-10, 19)];
                    invoicetotal.text = [NSString stringWithFormat:@"港幣 %.2f",[totalamount doubleValue]];
                    invoicetotal.textAlignment = NSTextAlignmentRight;
                    invoicetotal.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                    invoicetotal.numberOfLines = 1;
                    invoicetotal.adjustsFontSizeToFitWidth = YES;
                    
                    [cell.contentView addSubview:invoicetotal];
                    [cell.contentView addSubview:invoicetotallabel];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    self.paymentTextField = [[STPPaymentCardTextField alloc]
                                             initWithFrame:CGRectMake(15, 3, CGRectGetWidth(self.view.frame) - 30, 44)];;
                    self.paymentTextField.delegate = self;
                    self.paymentTextField.borderColor = [UIColor clearColor];
                    [cell.contentView addSubview:self.paymentTextField];
                    
                }
                    break;
                case 1:
                {
                    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    self.submitButton.frame = CGRectMake(10, 3, curwidth-20, 44);
                    self.submitButton.enabled = NO;
                    self.submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                    [self.submitButton setTitle:@"用信用卡結賬" forState:UIControlStateNormal];
                    [self.submitButton addTarget:self action:@selector(submitCard:) forControlEvents:UIControlEventTouchUpInside];
                    //[self.submitButton sizeToFit];
                    [cell.contentView addSubview:self.submitButton];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    self.submitButton.enabled = textField.isValid;
}
- (IBAction)submitCard:(id)sender {
    // If you have your own form for getting credit card information, you can construct
    // your own STPCardParams from number, month, year, and CVV.
    [self performSelectorOnMainThread:@selector(keyboardDidHide:) withObject:nil waitUntilDone:YES];
    UIView *activebackgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    activebackgroundview.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.6];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    [activityView startAnimating];
    [activebackgroundview addSubview:activityView];
    [self.view addSubview:activebackgroundview];
    STPCardParams* card = [self.paymentTextField cardParams];
    [[STPAPIClient sharedClient]
     createTokenWithCard:card
     completion:^(STPToken *token, NSError *error) {
         if (token) {
             NSLog(@"token %@", token);
             // TODO: send the token to your server so it can create a charge
             NSString *stripeAPI = @"sk_live_l2DDUGECfaw9i4hTmZ36ydyQ";
             NSString *float2 = [NSString stringWithFormat:@"%.2f", [self->totalamount doubleValue]];
             NSString *chargevalue = [float2 stringByReplacingOccurrencesOfString:@"." withString:@""];
             NSString *poststring = [NSString stringWithFormat:@"stripeToken=%@&paymentamount=%@&paymentcurrency=hkd&stripeAPI=%@&email=%@&pnumber=%@&shipstreet=%@&shipcity=%@&shipstate=%@&shippostal=%@&shipcountry=%@&firstname=%@&lastname=%@&transdetail=%@&cartdisc=%.2f&combincost=%@&combinqty=%@",token, chargevalue, stripeAPI, self->shipemail, self->shipphone, self->shipstreet, self->shiptcity, self->shipstate, self->shippostal, self->shipcountry, self->firstname, self->lastname,self->combinateresult,[self->discountamount doubleValue],self->combinatecost, self->combinateqty];
             
             //sent to webserver
             NSData *postData = [poststring dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
             NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[poststring length]];
             NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
             [request setURL:[NSURL URLWithString:@"https://www.vigorgems.com/temp/becharge_vg.php"]];
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
                     NSLog(@"%@", jsonData);
                     NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
                     if (success == 1) {
                         NSLog(@"Transition has been approved");
                         [self performSelectorOnMainThread:@selector(sendtoconfirmpage:) withObject:nil waitUntilDone:YES];
                         //debug the display error....
                         //dispatch_async(dispatch_get_main_queue(), ^{
                         //    [self.popupController customdismissPopupControllerAnimated:NO];
                         //    finishupview = [self.storyboard instantiateViewControllerWithIdentifier:@"finishupview"];
                         //    //NSString *typeofdoc = @"PT";
                         //    [self.navigationController pushViewController:finishupview animated:NO];
                         //});
                     } else {
                         NSLog(@"Transition has been rejected");
                         [activityView stopAnimating];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [activityView removeFromSuperview];
                             [activebackgroundview removeFromSuperview];
                             [self showalertdig];
                         });
                         
                         
                     }
                 } else {
                     NSLog(@"Fail: %@", error);
                     [activityView stopAnimating];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityView removeFromSuperview];
                         [activebackgroundview removeFromSuperview];
                         [self showalertdig];
                     });
                 }
                 
             }];
             [task resume];
             
             //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
             
             //if (conn) {
             //    NSLog(@"successful");
             //} else {
             //    NSLog(@"not successful");
             //}
             
         } else {
             NSLog(@"Error creating token: %@", error.localizedDescription);
             [activityView stopAnimating];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [activityView removeFromSuperview];
                 [activebackgroundview removeFromSuperview];
                 [self showalertdig];
             });
             
         }
     }];
}

-(void)keyboardDidShow:(NSNotification *) notif {
    NSLog(@"show keyboard");
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.5];
    tableview.frame = CGRectMake(0, 0, curwidth, curheigh-keyboardSize.height-40);
    [UITableView commitAnimations];
}
-(void)keyboardDidHide:(NSNotification *) notif {
    [self.paymentTextField resignFirstResponder];
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.5];
    tableview.frame = CGRectMake(0, 0, curwidth, curheigh);
    [UITableView commitAnimations];
}
-(IBAction)sentconfirm:(id)sender {
    NSLog(@"confirmed");
    
    UIView *activebackgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    activebackgroundview.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.6];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    [activityView startAnimating];
    [activebackgroundview addSubview:activityView];
    [self.view addSubview:activebackgroundview];
    
    NSString *poststring = [NSString stringWithFormat:@"paymentamount=%@&paymentcurrency=hkd&email=%@&pnumber=%@&shipstreet=%@&shipcity=%@&shipstate=%@&shippostal=%@&shipcountry=%@&firstname=%@&lastname=%@&transdetail=%@&cartdisc=%.2f&combincost=%@&combinqty=%@&paymethod=%@", totalamount, shipemail, shipphone, shipstreet, shiptcity, shipstate, shippostal, shipcountry, firstname, lastname,combinateresult,[discountamount doubleValue],combinatecost, combinateqty, typeofpayment];
    
    //sent to webserver
    NSData *postData = [poststring dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[poststring length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:@"https://www.vigorgems.com/temp/beconfirm_vg.php"]];
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
            NSLog(@"%@", jsonData);
            NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
            if (success == 1) {
                
                //[self performSelectorOnMainThread:@selector(sentconfirm:) withObject:nil waitUntilDone:YES];
                //debug the display error....
                //dispatch_async(dispatch_get_main_queue(), ^{
                //    [self.popupController customdismissPopupControllerAnimated:NO];
                //    finishupview = [self.storyboard instantiateViewControllerWithIdentifier:@"finishupview"];
                //    //NSString *typeofdoc = @"PT";
                //    [self.navigationController pushViewController:finishupview animated:NO];
                //});
                NSString *message = [jsonData objectForKey:@"message"];
                NSLog(@"%@", message);
                [activebackgroundview resignFirstResponder];
                [activityView resignFirstResponder];
                [self performSelectorOnMainThread:@selector(sendtoconfirmpage:) withObject:message waitUntilDone:YES];
            } else {
                NSLog(@"Transition has been rejected");
                [activityView stopAnimating];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityView removeFromSuperview];
                    [activebackgroundview removeFromSuperview];
                    [self showalertdig];
                });
                
                
            }
        } else {
            NSLog(@"Fail: %@", error);
            [activityView stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView removeFromSuperview];
                [activebackgroundview removeFromSuperview];
                [self showalertdig];
            });
        }
        
    }];
    [task resume];
}
-(void)showalertdig {
    NSLog(@"alert");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Transition Error:" message:@"The Card enter is declined" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(IBAction)sendtoconfirmpage:(id)sender {
    NSLog(@"%@", sender);
    
    successview = [self.storyboard instantiateViewControllerWithIdentifier:@"successView"];
    successview.responsevalue = totalamount;
    successview.responsestring = sender;
    //[self.navigationController pushViewController:successview animated:YES];
    [self.navigationController presentViewController:successview animated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
