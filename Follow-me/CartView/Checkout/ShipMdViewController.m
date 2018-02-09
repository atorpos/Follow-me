//
//  ShipMdViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "ShipMdViewController.h"

@interface ShipMdViewController ()

@end

@implementation ShipMdViewController
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    standarddefault = [NSUserDefaults standardUserDefaults];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    
    shippingmethod = [[NSArray alloc] initWithObjects:@"Air",@"DHL",@"EMS",@"Fedex",@"Surface",@"TNT",@"UPS", @"Pick up", nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"運送方式"];
    [self.view addSubview:tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shippingmethod count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [shippingmethod objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    [standarddefault setObject:[shippingmethod objectAtIndex:indexPath.row] forKey:@"shippingmethod"];
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
