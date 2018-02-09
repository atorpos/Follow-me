//
//  CouponViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "CouponViewController.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

@synthesize tableview, couponfield;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    defaults = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:0.8];
    self.navigationItem.title = [NSString stringWithFormat:@"Enter Coupon"];
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh-60) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
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
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
            couponfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, curwidth-10, 40)];
            couponfield.font = [UIFont systemFontOfSize:13];
            couponfield.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            [cell.contentView addSubview:couponfield];
            break;
        }
        case 1:
        {
            couponbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            couponbutton.frame = CGRectMake(5, 0, curwidth-10, 40);
            [couponbutton setTitle:@"Add Coupon" forState:UIControlStateNormal];
            [couponbutton addTarget:self action:@selector(savecoupon:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:couponbutton];
            break;
        }
        default:
            break;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headertitle;
    switch (section) {
        case 0:
            headertitle = @"Coupon Code";
            break;
        default:
            break;
    }
    return headertitle;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    int rowheight;
    switch (section) {
        case 0:
            rowheight = 60;
            break;
        case 1:
            rowheight = 40;
            break;
        default:
            rowheight = 60;
            break;
    }
    return rowheight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}
-(IBAction)savecoupon:(id)sender {
    NSLog(@"saving coupon");
    [defaults setObject:couponfield.text forKey:@"cartcoupon"];
    [self.navigationController popViewControllerAnimated:YES];
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
