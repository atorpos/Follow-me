//
//  CheckoutViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2018/02/01.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "CheckoutViewController.h"
#import "SuccessViewController.h"
#import "ShipMdViewController.h"
#import "ShipAddViewController.h"
#import "PaymentViewController.h"
#import "CouponViewController.h"
#import "PaymentInputViewController.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController
@synthesize tableview, cartproducts, cartsubtotal, cartqty, itemsutotal, itemid, itemimg;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    taxtotal = 0;
    discounttotal = 0;
    
    subtotal = [cartsubtotal doubleValue];
    defaults = [NSUserDefaults standardUserDefaults];
    obejct = [defaults objectForKey:@"username"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:1];
    self.navigationItem.title = [NSString stringWithFormat:@"結賬"];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh-60) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    bottomcolmn = [[UIView alloc] init];
    if(curheigh == 812.00000) {
        bottomcolmn.frame = CGRectMake(0, curheigh-144, curwidth, 60);
    } else {
        bottomcolmn.frame = CGRectMake(0, curheigh-109, curwidth, 60);
    }
    //cancelsbtm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelpage:)];
    //[self.navigationItem setRightBarButtonItem:cancelsbtm];
    
    bottomcolmn.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    processbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    processbutton.frame = CGRectMake(0, 0, curwidth, 60);
    processbutton.backgroundColor =[UIColor colorWithRed:0.41 green:0.85 blue:0.38 alpha:0.8];
    [processbutton setTitle:@"信用卡結賬" forState:UIControlStateNormal];
    [processbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    processbutton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [processbutton addTarget:self action:@selector(proccssnext:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomcolmn addSubview:processbutton];
    [self.view addSubview:bottomcolmn];
}
-(void)viewDidAppear:(BOOL)animated {
    //NSLog(@"%@", itemimg);
    [tableview reloadData];
}
-(void)viewDidDisappear:(BOOL)animated {
    taxtotal = 0;
    discounttotal = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int nuofrow;
    if (section == 0) {
        nuofrow = (int)[cartproducts count]+1;
    } else {
        nuofrow = 4;
    }
    return nuofrow;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Total";
            break;
        case 1:
            sectionName = @"Information";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 40)];
    //headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:0.8];
    UILabel *headerlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 22, 315, 13)];
    headerlabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightUltraLight];
    switch (section) {
        case 0:
            headerlabel.text = @"Summary of Total";
            break;
        case 1:
            headerlabel.text = @"More Information";
            break;
        default:
            break;
    }
    [headerView addSubview:headerlabel];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 13)];
    //headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:0.8];
    UILabel *headerlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 22, 315, 13)];
    headerlabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightUltraLight];
    switch (section) {
        case 0:
            
            break;
        case 1:
            break;
        default:
            break;
    }
    headerlabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerlabel];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if(indexPath.section == 0) {
        if (indexPath.row <[cartproducts count]) {
            UILabel *itemname = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 2, curwidth/4*2, 38)];
            itemname.numberOfLines = 0;
            itemname.lineBreakMode = NSLineBreakByWordWrapping;
            itemname.textAlignment = NSTextAlignmentLeft;
            itemname.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
            itemname.text = [NSString stringWithFormat:@"%@ x %@", [cartqty objectAtIndex:indexPath.row], [cartproducts objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:itemname];
            double itemsubtotalvalue = [[cartqty objectAtIndex:indexPath.row] doubleValue] * [[itemsutotal objectAtIndex:indexPath.row] doubleValue];
            UILabel *itemsubtotal = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4*3, 2, curwidth/4-2, 38)];
            itemsubtotal.text = [NSString stringWithFormat:@"港幣 %.2f", itemsubtotalvalue];
            itemsubtotal.textAlignment = NSTextAlignmentRight;
            itemsubtotal.adjustsFontSizeToFitWidth = YES;
            [cell.contentView addSubview:itemsubtotal];
            UIImageView *itempicview = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 46, 46)];
            [itempicview setImage:[UIImage imageWithData:[itemimg objectAtIndex:indexPath.row]]];
            itempicview.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:itempicview];
        } else {
            UILabel *subtotallabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 2, curwidth/2-2, 27)];
            subtotallabel.text = [NSString stringWithFormat:@"小計: 港幣"];
            subtotallabel.adjustsFontSizeToFitWidth = YES;
            subtotallabel.font = [UIFont systemFontOfSize:11];
            subtotallabel.numberOfLines = 1;
            subtotallabel.textAlignment = NSTextAlignmentRight;
            
            UILabel *subtotalvaluelabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4*3, 2, curwidth/4-2, 27)];
            
            subtotalvaluelabel.text = [NSString stringWithFormat:@"%.2f", [cartsubtotal doubleValue]];
            
            subtotalvaluelabel.adjustsFontSizeToFitWidth = YES;
            subtotalvaluelabel.font = [UIFont systemFontOfSize:13];
            subtotalvaluelabel.numberOfLines = 1;
            subtotalvaluelabel.textAlignment = NSTextAlignmentRight;
            
            UILabel *taxlabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 30, curwidth/2-2, 27)];
            taxlabel.text = [NSString stringWithFormat:@"稅, 運費: 港幣"];
            taxlabel.adjustsFontSizeToFitWidth = YES;
            taxlabel.font = [UIFont systemFontOfSize:11];
            taxlabel.numberOfLines = 1;
            taxlabel.textAlignment = NSTextAlignmentRight;
            UILabel *taxvaluelabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4*3, 30, curwidth/4-2, 27)];
            taxvaluelabel.text = [NSString stringWithFormat:@"%.2f", taxtotal];
            taxvaluelabel.adjustsFontSizeToFitWidth = YES;
            taxvaluelabel.font = [UIFont systemFontOfSize:13];
            taxvaluelabel.numberOfLines = 1;
            taxvaluelabel.textAlignment = NSTextAlignmentRight;
            
            UILabel *discountlabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 58, curwidth/2-2, 27)];
            discountlabel.text = [NSString stringWithFormat:@"減價: "];
            discountlabel.textColor = [UIColor redColor];
            discountlabel.adjustsFontSizeToFitWidth = YES;
            discountlabel.font = [UIFont systemFontOfSize:11];
            discountlabel.numberOfLines = 1;
            discountlabel.textAlignment = NSTextAlignmentRight;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(52, 87)];
            [path addLineToPoint:CGPointMake(curwidth-2, 87)];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = [path CGPath];
            shapeLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
            shapeLayer.lineWidth = 0.5;
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            
            UILabel *totallabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4, 86, curwidth/2-2, 27)];
            totallabel.text = [NSString stringWithFormat:@"總數: 港幣"];
            totallabel.textColor = [UIColor blackColor];
            totallabel.adjustsFontSizeToFitWidth = YES;
            totallabel.font = [UIFont systemFontOfSize:13];
            totallabel.numberOfLines = 1;
            totallabel.textAlignment = NSTextAlignmentRight;
            
            invtotal = subtotal + taxtotal - discounttotal;
            
            UILabel *totalvaluelabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/4*3, 86, curwidth/4-2, 27)];
            totalvaluelabel.text = [NSString stringWithFormat:@"%.2f", invtotal];
            
            totalvaluelabel.textColor = [UIColor blackColor];
            totalvaluelabel.adjustsFontSizeToFitWidth = YES;
            totalvaluelabel.font = [UIFont systemFontOfSize:15];
            totalvaluelabel.numberOfLines = 1;
            totalvaluelabel.textAlignment = NSTextAlignmentRight;
            
            [cell.contentView.layer addSublayer:shapeLayer];
            [cell.contentView addSubview:discountlabel];
            [cell.contentView addSubview:taxlabel];
            [cell.contentView addSubview:subtotallabel];
            [cell.contentView addSubview:totallabel];
            [cell.contentView addSubview:subtotalvaluelabel];
            [cell.contentView addSubview:taxvaluelabel];
            [cell.contentView addSubview:totalvaluelabel];
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, curwidth-5, 13)];
                titlelabel.text = @"運送方式：";
                titlelabel.textAlignment = NSTextAlignmentLeft;
                titlelabel.adjustsFontSizeToFitWidth = YES;
                titlelabel.font = [UIFont systemFontOfSize:11];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.contentView addSubview:titlelabel];
                UILabel *shipmethod = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, curwidth-5, 30)];
                shipmethod.textAlignment = NSTextAlignmentLeft;
                shipmethod.adjustsFontSizeToFitWidth = YES;
                shipmethod.font = [UIFont systemFontOfSize:13];
                if ([[defaults objectForKey:@"shippingmethod"] length] == 0) {
                    shipmethod.text = @"未選取運送方式";
                } else {
                    shipmethod.text = [defaults objectForKey:@"shippingmethod"];
                }
                [cell.contentView addSubview:shipmethod];
                [cell.contentView addSubview:titlelabel];
            }
                break;
            case 1:
            {
                UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, curwidth-5, 13)];
                titlelabel.text = @"運送地址：";
                titlelabel.textAlignment = NSTextAlignmentLeft;
                titlelabel.adjustsFontSizeToFitWidth = YES;
                titlelabel.font = [UIFont systemFontOfSize:11];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *shipaddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, curwidth-5, 30)];
                NSString *stringaddress = [NSString stringWithFormat:@"%@, %@, %@, %@", [defaults objectForKey:@"shipname"],[defaults objectForKey:@"shiplname"],[defaults objectForKey:@"shipaddress"],[defaults objectForKey:@"shipcountry"]];
                shipaddress.text = stringaddress;
                shipaddress.textAlignment = NSTextAlignmentLeft;
                shipaddress.adjustsFontSizeToFitWidth = YES;
                shipaddress.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:shipaddress];
                [cell.contentView addSubview:titlelabel];
            }break;
            case 2:
            {
                UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, curwidth-5, 13)];
                titlelabel.text = @"Coupon code";
                titlelabel.textAlignment = NSTextAlignmentLeft;
                titlelabel.adjustsFontSizeToFitWidth = YES;
                titlelabel.font = [UIFont systemFontOfSize:11];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.contentView addSubview:titlelabel];
            }
                break;
            default:
                break;
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowheight;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row < [cartproducts count]) {
                rowheight = 60;
            } else {
                rowheight = 120;
            }
        }
            break;
        case 1:
            rowheight = 60;
            break;
        default:
            rowheight = 60;
            break;
    }
    
    return rowheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    shipmdview = [self.storyboard instantiateViewControllerWithIdentifier:@"shipmethodview"];
                    [self.navigationController pushViewController:shipmdview animated:YES];
                    
                    break;
                }
                case 1:
                {
                    shipaddview = [self.storyboard instantiateViewControllerWithIdentifier:@"Shipaddview"];
                    [self.navigationController pushViewController:shipaddview animated:YES];
                    break;
                }
                case 2:
                {
                    couponview = [self.storyboard instantiateViewControllerWithIdentifier:@"couponview"];
                    [self.navigationController pushViewController:couponview animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)proccssnext:(id)sender {
    NSLog(@"%@", [NSString stringWithFormat:@"touchupinside %@", firstname]);
    if (![defaults objectForKey:@"shipemail"]) {
        NSLog(@"No String");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please input your Additional information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else {
        if (![defaults objectForKey:@"shipname"]) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Information is Required"
                                          message:@"Please enter your shipping information"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            
        } else if (![defaults objectForKey:@"shippingmethod"]) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Information is Required"
                                          message:@"Please select your Shipping method"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
        }else {
            paymentinput = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentinput"];
            paymentinput.typeofpayment = @"credit card";
            paymentinput.totalamount = [NSString stringWithFormat:@"%f", invtotal];
            paymentinput.subtotalamount = [NSString stringWithFormat:@"%f", subtotal];
            paymentinput.shippingamount = [NSString stringWithFormat:@"%f", taxtotal];
            paymentinput.discountamount = [NSString stringWithFormat:@"%f", discounttotal];
            paymentinput.firstname = [defaults objectForKey:@"shipname"];
            paymentinput.lastname = [defaults objectForKey:@"shiplname"];
            paymentinput.companyname = [defaults objectForKey:@"shipcompany"];
            paymentinput.shipstreet = [defaults objectForKey:@"shipaddress"];
            paymentinput.shiptcity = [defaults objectForKey:@"shipcity"];
            paymentinput.shipcountry = [defaults objectForKey:@"shipcountry"];
            paymentinput.shipstate = [defaults objectForKey:@"shipstates"];
            paymentinput.shippostal = [defaults objectForKey:@"shippostal"];
            paymentinput.shipphone = [defaults objectForKey:@"shiptel"];
            paymentinput.shipemail = [defaults objectForKey:@"shipemail"];
            paymentinput.shipnote = [defaults objectForKey:@"shipnote"];
            paymentinput.combinateresult = combinateresult;
            paymentinput.combinatecost = combinatecost;
            paymentinput.combinateqty = combinateqty;
            [self.navigationController pushViewController:paymentinput animated:YES];
        }
        
    }
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
