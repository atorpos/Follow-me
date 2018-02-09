//
//  SubSecViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2018/01/22.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "SubSecViewController.h"
#import "ProductDetailViewController.h"

@interface SubSecViewController ()

@end

@implementation SubSecViewController
@synthesize catnum, catname, productnamearray, stockstatus, regularprice, saleprice, tecrating, imgurl, productid;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",catnum);
    readpage = 0;
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    productnamearray = [[NSMutableArray alloc] init];
    stockstatus = [[NSMutableArray alloc] init];
    regularprice = [[NSMutableArray alloc] init];
    saleprice = [[NSMutableArray alloc] init];
    imgurl = [[NSMutableArray alloc] init];
    tecrating = [[NSMutableArray alloc] init];
    productid = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
}
-(void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@", catname];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.6]];
    [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
    
}
-(void)creatview {
    mainview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh) style:UITableViewStylePlain];
    mainview.delegate = self;
    mainview.dataSource = self;
    mainview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:mainview];
}
-(void)getserverfile:(NSString *)loadpage{
    NSString *sentoproustrting = [NSString stringWithFormat:@"cid=%@&lastitem=%@", catnum,loadpage];
    NSString *stringofurl = @"https://www.follow-me.pro/parsejson_catproduct.php";
    NSData *postdata = [sentoproustrting dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *stringlength = [NSString stringWithFormat:@"%lu", (unsigned long)[sentoproustrting length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:stringofurl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:stringlength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postdata];
    [request setTimeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response &&! error) {
            readtext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (![readtext isEqualToString:@"no value"]) {
                if(loadpage == 0) {
                    [self performSelectorOnMainThread:@selector(fetchproducts:) withObject:data waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(fetchaddproducts:) withObject:data waitUntilDone:YES];
                }
            } else {
                NSLog(@"no value");
            }
        }
    }];
    
    [task resume];
}
-(void)fetchproducts:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    countarray = [NSString stringWithFormat:@"%@", [[json valueForKeyPath:@"count"] objectAtIndex:0]];
    productnamearray = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"post_title"] objectAtIndex:0];
    stockstatus = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_stock_status"] objectAtIndex:0];
    regularprice = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_regular_price"] objectAtIndex:0];
    saleprice = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_price"] objectAtIndex:0];
    imgurl = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"imgurl"] objectAtIndex:0];
    tecrating = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_wc_average_rating"] objectAtIndex:0];    NSLog(@"first ns log %@",regularprice);
    productid = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"ID"] objectAtIndex:0];
    //NSLog(@"%@", [[productnamearray objectAtIndex:1] objectAtIndex:0]);
    [self creatview];
    [mainview reloadData];
}
-(void)fetchaddproducts:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSMutableArray *tempname = [[NSMutableArray alloc] initWithArray:productnamearray];
    productnamearray = nil;
    NSMutableArray *servername = [[NSMutableArray alloc] init];
    servername = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"post_title"] objectAtIndex:0];
    self.productnamearray = [NSMutableArray arrayWithArray:[tempname arrayByAddingObjectsFromArray:servername]];
    
    NSMutableArray *tempstatus = [[NSMutableArray alloc] initWithArray:stockstatus];
    stockstatus = nil;
    NSMutableArray *serverstatus = [[NSMutableArray alloc] init];
    serverstatus = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_stock_status"] objectAtIndex:0];
    self.stockstatus = [NSMutableArray arrayWithArray:[tempstatus arrayByAddingObjectsFromArray:serverstatus]];
    
    NSMutableArray *tempregularprice = [[NSMutableArray alloc] initWithArray:regularprice];
    regularprice = nil;
    NSMutableArray *serverregualrprice = [[NSMutableArray alloc] init];
    serverregualrprice = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_regular_price"] objectAtIndex:0];
    self.regularprice = [NSMutableArray arrayWithArray:[tempregularprice arrayByAddingObjectsFromArray:serverregualrprice]];
    
    NSMutableArray *tempsale = [[NSMutableArray alloc] initWithArray:saleprice];
    saleprice = nil;
    NSMutableArray *serversale = [[NSMutableArray alloc] init];
    serversale = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_price"] objectAtIndex:0];
    self.saleprice = [NSMutableArray arrayWithArray:[tempsale arrayByAddingObjectsFromArray:serversale]];
    
    NSMutableArray *temprat = [[NSMutableArray alloc] initWithArray:tecrating];
    tecrating = nil;
    NSMutableArray *serverrat = [[NSMutableArray alloc] init];
    serverrat = [[[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"meta"]valueForKeyPath:@"_wc_average_rating"] objectAtIndex:0];
    self.tecrating = [NSMutableArray arrayWithArray:[temprat arrayByAddingObjectsFromArray:serverrat]];
    
    NSMutableArray *tempimg = [[NSMutableArray alloc] initWithArray:imgurl];
    imgurl = nil;
    NSMutableArray *serverimg = [[NSMutableArray alloc] init];
    serverimg = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"imgurl"] objectAtIndex:0];
    self.imgurl = [NSMutableArray arrayWithArray:[tempimg arrayByAddingObjectsFromArray:serverimg]];
    
    NSMutableArray *tempid = [[NSMutableArray alloc] initWithArray:productid];
    productid = nil;
    NSMutableArray *serverid = [[NSMutableArray alloc] init];
    serverid = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"ID"] objectAtIndex:0];
    self.productid = [NSMutableArray arrayWithArray:[tempid arrayByAddingObjectsFromArray:serverid]];
    NSLog(@"the no of row, %lu", (unsigned long)[productnamearray count]);
    [mainview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [productnamearray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [mainview dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        //cell.textLabel.text = [[productnamearray objectAtIndex:indexPath.row] objectAtIndex:0];
        UIImageView *imageview =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[imgurl objectAtIndex:indexPath.row] objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        UILabel *itemlabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, curwidth-100, 40)];
        itemlabel.lineBreakMode = NSLineBreakByWordWrapping;
        itemlabel.numberOfLines = 2;
        itemlabel.textAlignment = NSTextAlignmentLeft;
        itemlabel.text = [[productnamearray objectAtIndex:indexPath.row] objectAtIndex:0];
        itemlabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        UILabel *iteminstock = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, curwidth/2-100, 17)];
        iteminstock.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        
        if ([[[stockstatus objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"instock"]) {
            iteminstock.text = @"在庫";
            iteminstock.textColor = [UIColor colorWithRed:0.66 green:0.72 blue:0.53 alpha:0.8];
        } else {
            iteminstock.text = @"售完";
            iteminstock.textColor = [UIColor colorWithRed:0.73 green:0.18 blue:0.23 alpha:0.8];
        }
        
        UILabel *salelabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/3*2-20, 55, curwidth/3+15, 21)];
        salelabel.text = [NSString stringWithFormat:@"HKD %.2f", [[[saleprice objectAtIndex:indexPath.row] objectAtIndex:0] doubleValue]];
        salelabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
        salelabel.textAlignment = NSTextAlignmentLeft;
        salelabel.textColor = [UIColor blackColor];
        UIImageView *ratingview = [[UIImageView alloc] initWithFrame:CGRectMake(90, 75, 97, 20)];
        ratingview.contentMode = UIViewContentModeScaleAspectFit;
        switch ([[[tecrating objectAtIndex:indexPath.row] objectAtIndex:0] integerValue]) {
            case 0:
                ratingimage =[UIImage imageNamed:@"5-stars.png"];
                break;
            case 1:
                ratingimage =[UIImage imageNamed:@"1-stars.png"];
                break;
            case 2:
                ratingimage =[UIImage imageNamed:@"2-stars.png"];
                break;
            case 3:
                ratingimage =[UIImage imageNamed:@"3-stars.png"];
                break;
            case 4:
                ratingimage =[UIImage imageNamed:@"4-stars.png"];
                break;
            case 5:
                ratingimage =[UIImage imageNamed:@"5-stars.png"];
                break;
            default:
                break;
        }
        
        [ratingview setImage:ratingimage];
        
        
        if([[[saleprice objectAtIndex:indexPath.row] objectAtIndex:0] doubleValue] != [[[regularprice objectAtIndex:indexPath.row] objectAtIndex:0] doubleValue] && ![[[regularprice objectAtIndex:indexPath.row] objectAtIndex:0]  isEqual: @""]) {
            regularlabel = [[UILabel alloc] initWithFrame:CGRectMake(curwidth/3*2-10, 81, curwidth/3+10, 19)];
            regularlabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
            NSAttributedString *crosstitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"HKD %.2f",[[[regularprice objectAtIndex:indexPath.row] objectAtIndex:0] doubleValue]] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
            regularlabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
            [regularlabel setAttributedText:crosstitle];
            [cell.contentView addSubview:regularlabel];
            
        }
        [cell.contentView addSubview:ratingview];
        [cell.contentView addSubview:salelabel];
        [cell.contentView addSubview:iteminstock];
        [cell.contentView addSubview:itemlabel];
        [cell.contentView addSubview:imageview];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    productview =  productview = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    productview.detailtitle = [[productnamearray objectAtIndex:indexPath.row] objectAtIndex:0];
    productview.postid = [[productid objectAtIndex:indexPath.row] objectAtIndex:0];
    productview.price = [[saleprice objectAtIndex:indexPath.row] objectAtIndex:0];
    productview.regularprice = [[regularprice objectAtIndex:indexPath.row] objectAtIndex:0];
    [self.navigationController pushViewController:productview animated:YES];
    [mainview deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [mainview numberOfSections] - 1;
    NSInteger lastRowIndex = [mainview numberOfRowsInSection:lastSectionIndex] - 1;
    
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        readpage = [NSString stringWithFormat:@"%d",[readpage intValue] + 1];
        NSLog(@"end action %@", readpage);
        [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
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
