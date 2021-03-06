//
//  ProductDetailViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 1/11/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailWebViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController
@synthesize detailtitle, postid, postcontent, price, regularprice;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    defaults = [NSUserDefaults standardUserDefaults];
    imagdata = [[NSData alloc] init];
    if (curheigh == 812.000000) {
        maintableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh-133) style:UITableViewStylePlain];
    } else {
        maintableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh-99) style:UITableViewStylePlain];
    }
    maintableview.delegate = self;
    maintableview.dataSource = self;
    maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    galleryurl = [[NSArray alloc] init];
    [self.view addSubview:maintableview];
    NSLog(@"%f", self.view.safeAreaInsets.bottom);
    [self cartview];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.6]];
}
-(void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = detailtitle;
    havevariation = NO;
    var_sku = @"";
    NSString *sentoproustrting = [NSString stringWithFormat:@"pid=%@", postid];
    NSString *stringofurl = @"https://www.follow-me.pro/parsejson_detail.php";
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
            self->readtext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (![self->readtext isEqualToString:@"no value"]) {
                [self performSelectorOnMainThread:@selector(fetchproducts:) withObject:data waitUntilDone:YES];
            } else {
                NSLog(@"no value");
            }
        }
    }];
    
    [task resume];
    
    NSLog(@"%@", sentoproustrting);
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSData *urlData_img = [NSData dataWithContentsOfURL:[NSURL URLWithString:productimg]];
    //NSString *filepath_fav = [NSString stringWithFormat:@"%@/share.jpg", documentsDirectory];
    //[urlData_img writeToFile:filepath_fav atomically:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    
}
-(void)cartview {
    UIView *cartview = [[UIView alloc] init];
    if (curheigh == 812.000000) {
        cartview.frame = CGRectMake(0, curheigh-133, curwidth, 50);
    } else {
        cartview.frame = CGRectMake(0, curheigh-99, curwidth, 50);
    }
    
    cartview.backgroundColor = [UIColor whiteColor];
    
    UIButton *addtocart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addtocart.frame = CGRectMake(curwidth/2, 0, curwidth/2, 50);
    addtocart.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.72 alpha:0.5];
    [addtocart setTitle:@"加入購物車" forState:UIControlStateNormal];
    [addtocart setTintColor:[UIColor whiteColor]];
    addtocart.tag = 0;
    [addtocart addTarget:self action:@selector(senttobucket:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *addtolist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addtolist.frame = CGRectMake(0, 0, curwidth/2, 50);
    addtolist.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [addtolist setTitle:@"加入清單" forState:UIControlStateNormal];
    [addtolist setTintColor:[UIColor colorWithRed:0.24 green:0.47 blue:0.72 alpha:0.8]];
    addtolist.tag = 1;
    [addtolist addTarget:self action:@selector(senttobucket:) forControlEvents:UIControlEventTouchUpInside];
    [cartview addSubview:addtolist];
    [cartview addSubview:addtocart];
    [self.view addSubview:cartview];
}
-(IBAction)senttobucket:(id)sender {
    if (detailtitle) {
        UIButton *passvalue = (UIButton *)sender;
        NSLog(@"%ld",(long)passvalue.tag);
        NSString *collectid = [NSString stringWithFormat:@""];
        if ([var_sku containsString:@""]) {
            collectid = postid;
        } else {
            collectid = var_sku;
        }
        switch (passvalue.tag) {
            case 0:
            {
                NSLog(@"select to cart");
                if([defaults objectForKey:@"chooseitemid"]) {
                    NSLog(@"more than one");
                    NSMutableArray *temppostidarray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"chooseitemid"]];
                    NSMutableArray *temppostno = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"chooseitemno"]];
                    NSMutableArray *tempposprice = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"chooseitemprice"]];
                    NSMutableArray *temppostitle = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"choseitemtitle"]];
                    NSMutableArray *tempimg = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"choseitemimg"]];
                    if (![temppostidarray containsObject:collectid]) {
                        [temppostidarray addObject:collectid];
                        [defaults setObject:temppostidarray forKey:@"chooseitemid"];
                        [temppostno addObject:[NSString stringWithFormat:@"1"]];
                        [defaults setObject:temppostno forKey:@"chooseitemno"];
                        [tempposprice addObject:price];
                        [defaults setObject:tempposprice forKey:@"chooseitemprice"];
                        [temppostitle addObject:detailtitle];
                        [defaults setObject:temppostitle forKey:@"choseitemtitle"];
                        [tempimg addObject:imagdata];
                        [defaults setObject:tempimg forKey:@"choseitemimg"];
                    } else {
                        int i = 0;
                        for (i =0; i<[temppostidarray count]; i++) {
                            if([temppostidarray objectAtIndex:i] == collectid) {
                                temppostno[i] = [NSString stringWithFormat:@"%d", [[temppostno objectAtIndex:i] intValue] +1];
                            }
                        }
                        [defaults setObject:temppostno forKey:@"chooseitemno"];
                        NSLog(@"%@ %@ %@", [defaults objectForKey:@"chooseitemno"], [defaults objectForKey:@"chooseitemprice"], [defaults objectForKey:@"choseitemtitle"]);
                    }
                    
                } else {
                    NSLog(@"just one");
                    NSMutableArray *temppostidarray = [[NSMutableArray alloc] initWithObjects:collectid, nil];
                    [defaults setObject:temppostidarray forKey:@"chooseitemid"];
                    NSMutableArray *temppostno = [[NSMutableArray alloc] initWithObjects:@"1", nil];
                    [defaults setObject:temppostno forKey:@"chooseitemno"];
                    NSMutableArray *tempposprice = [[NSMutableArray alloc] initWithObjects:price, nil];
                    [defaults setObject:tempposprice forKey:@"chooseitemprice"];
                    NSMutableArray *temppostitle = [[NSMutableArray alloc] initWithObjects:detailtitle, nil];
                    [defaults setObject:temppostitle forKey:@"choseitemtitle"];
                    NSMutableArray *tempimg = [[NSMutableArray alloc] initWithObjects:imagdata, nil];
                    [defaults setObject:tempimg forKey:@"choseitemimg"];
                }
                
                [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [[defaults objectForKey:@"chooseitemid"] count]];
            }
                break;
            case 1:
                NSLog(@"slect to list");
                break;
            default:
                break;
        }
    }
    
}
-(void)fetchproducts:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    //NSLog(@"json %@", json);
    readtext = [[json valueForKey:@"post_title"] objectAtIndex:0];
    mainimgurl = [[json valueForKeyPath:@"imgurl"] objectAtIndex:0];
    if([[json valueForKeyPath:@"galleryurl"]objectAtIndex:0]) {
        galleryurl = [[json valueForKeyPath:@"galleryurl"]objectAtIndex:0];
    }
    detailtitle = [[json valueForKeyPath:@"post_title"] objectAtIndex:0];
    productdescriptions = [[json valueForKeyPath:@"shorttitle"] objectAtIndex:0];
    stocks = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_stock"] objectAtIndex:0];
    productweight = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_weight"] objectAtIndex:0];
    productwidth = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_width"] objectAtIndex:0];
    productheight = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_height"] objectAtIndex:0];
    productlength = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_length"] objectAtIndex:0];
    productsdk = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_sku"] objectAtIndex:0];
    price = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_price"] objectAtIndex:0];
    regularprice = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_regular_price"] objectAtIndex:0];
    stock_status = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_stock_status"] objectAtIndex:0];
    productrating = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_wc_average_rating"] objectAtIndex:0];
    noofrating = [[[json valueForKeyPath:@"meta"] valueForKeyPath:@"_wc_review_count"] objectAtIndex:0];
    if([galleryurl count] > 0) {
        
    } else {
        [self loadingoneimg];
    }
    
    if([[json valueForKeyPath:@"product_variation"] objectAtIndex:0] != (id)[NSNull null]){
        havevariation = YES;
        productvariations = [[NSDictionary alloc] init];
        productvariations = [[json valueForKeyPath:@"product_variation"] objectAtIndex:0];
        //NSArray *keypart = [[NSArray alloc] initWithArray:[productvariations allKeys]];
        //NSLog(@"count of var %lu",(unsigned long)[keypart count]);
        [self showvariations:nil];
    }
    
    [maintableview reloadData];
    
}
-(void)loadingoneimg {
    
}
-(void)showvariations:(id)sender {
    optionareaheight = 70*[productvariations count]+40;
    NSLog(@"height of view %f, %@", optionareaheight, sender);
    buttonview = [[UIView alloc] init];
    buttonview.frame = CGRectMake(0, 0, variationsbuttonview.frame.size.width, variationsbuttonview.frame.size.height);
    int i = 0;
    for (id variationsku in productvariations) {
        NSLog(@"show variable %@", [[productvariations valueForKey:variationsku] valueForKey:@"variation"]);
        UIButton *choosebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        choosebutton.frame = CGRectMake(20, 60*i+5, buttonview.frame.size.width-40, 55);
        choosebutton.layer.borderWidth = 0.5f;
        if (![variationsku isEqualToString:sender]) {
            choosebutton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        } else {
            choosebutton.layer.borderColor = [UIColor redColor].CGColor;
        }
        choosebutton.layer.cornerRadius = 8.0f;
        i++;
        choosebutton.tag = [variationsku integerValue];
        //choosebutton.titleLabel.text = [NSString stringWithFormat:@"%@", [[productvariations valueForKey:variationsku] valueForKey:@"variation"]];
        [choosebutton setTitle:[[productvariations valueForKey:variationsku] valueForKey:@"variation"] forState:UIControlStateNormal];
        [choosebutton addTarget:self action:@selector(sentoption:) forControlEvents:UIControlEventTouchUpInside];
        [buttonview addSubview:choosebutton];
        NSLog(@"for the loop %@", variationsku);
    }
    [variationsbuttonview addSubview:buttonview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tag for choosing the option
-(IBAction)sentoption:(id)sender {
    UIButton *passvalue = (UIButton *)sender;
    NSLog(@"the log %ld", (long)passvalue.tag);
    var_sku = [NSString stringWithFormat:@"%ld", (long)passvalue.tag];
    [buttonview removeFromSuperview];
    [self showvariations:var_sku];
}

#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (havevariation == NO) {
       return 2;
    } else {
        return 3;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    } else {
        return 1;
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [maintableview dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if(cell == nil) {
        if (havevariation == NO) {
            if (indexPath.section == 1) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                switch (indexPath.row) {
                    case 0:
                    {
                        //cell.textLabel.text = @"描述";
                        
                        UILabel *toplable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, curwidth-20, 27)];
                        toplable.text = @"詳細資料";
                        
                        NSString *htmlstirng = productdescriptions;
                        htmlstirng = [htmlstirng stringByAppendingString:@"<style>body{font-family:HelveticaNeue-Light; font-size:17px; color: #8e8e93; text-align: right;}</style>"];
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlstirng dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, curwidth-40, 40)];
                        textview.userInteractionEnabled = NO;
                        textview.attributedText = attributedString;
                        textview.textAlignment = NSTextAlignmentCenter;
                        textviewframe = textview.frame;
                        textviewframe.size.height = [textview contentSize].height+50;
                        textview.frame = textviewframe;
                        [cell.contentView addSubview:toplable];
                        [cell.contentView addSubview:textview];
                    }
                        break;
                    default:
                        break;
                }
            } else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                switch (indexPath.row) {
                    case 0:
                    {
                        UIView *addview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 70)];
                        
                        UILabel *producname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, curwidth-20, 50)];
                        producname.text = readtext;
                        producname.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
                        producname.textAlignment = NSTextAlignmentLeft;
                        producname.lineBreakMode = NSLineBreakByWordWrapping;
                        producname.numberOfLines = 2;
                        
                        CALayer *tlayer = [addview layer];
                        CALayer *topborder = [CALayer layer];
                        topborder.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor;
                        topborder.borderWidth = 1;
                        topborder.frame = CGRectMake(0, 1, tlayer.frame.size.width, 1);
                        [topborder setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor];
                        UIImageView *ratingview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 97, 20)];
                        
                        ratingview.contentMode = UIViewContentModeScaleAspectFit;
                        switch ([productrating integerValue]) {
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
                        UILabel *noofrating_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 52, 97, 16)];
                        noofrating_label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
                        noofrating_label.textAlignment = NSTextAlignmentLeft;
                        if ([noofrating integerValue] == 0) {
                            noofrating_label.text = [NSString stringWithFormat:@"( %@ 評分)",[postid substringToIndex:2]];
                        } else {
                            noofrating_label.text = [NSString stringWithFormat:@"( %@ 評分)", noofrating];
                        }
                        
                        [ratingview setImage:ratingimage];
                        
                        [tlayer addSublayer:topborder];
                        [addview addSubview:noofrating_label];
                        [addview addSubview:ratingview];
                        [addview addSubview:producname];
                        [cell.contentView addSubview:addview];
                        break;
                    }
                        
                        
                    case 1:
                    {
                        
                        [heroimgview removeFromSuperview];
                        if(!galleryurl) {
                            heroimgview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
                            UIImageView *testview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
                            [testview sd_setImageWithURL:[NSURL URLWithString:mainimgurl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                            //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[productimg objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                            imagdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:mainimgurl]];
                            
                            testview.contentMode = UIViewContentModeScaleAspectFit;
                            testview.clipsToBounds = YES;
                            [heroimgview addSubview:testview];
                        } else {
                            if([galleryurl count] > 0) {
                                int i;
                                NSInteger noofpic = [galleryurl count];
                                heroimgview = [[UIScrollView alloc] init];
                                heroimgview.frame = CGRectMake(0, 0, curwidth, curwidth/4*3);
                                heroimgview.contentSize = CGSizeMake(curwidth*(noofpic+1), curwidth/4*3);
                                heroimgview.scrollEnabled = YES;
                                heroimgview.pagingEnabled = YES;
                                heroimgview.delegate = self;
                                heroimgview.clipsToBounds = YES;
                                heroimgview.backgroundColor = [UIColor whiteColor];
                                
                                UIImageView *testview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
                                [testview sd_setImageWithURL:[NSURL URLWithString:mainimgurl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                                //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[productimg objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                                imagdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:mainimgurl]];
                                
                                testview.contentMode = UIViewContentModeScaleAspectFit;
                                testview.clipsToBounds = YES;
                                [heroimgview addSubview:testview];
                                
                                for (i=0; i<[galleryurl count]; i++) {
                                    [self performSelectorOnMainThread:@selector(createview:) withObject:[NSString stringWithFormat:@"%d", i] waitUntilDone:YES];
                                }
                                //[self performSelector:@selector(createview:) withObject:[NSString stringWithFormat:@"%lu", (unsigned long)[galleryurl count]] afterDelay:0];
                            }
                        }
                        [cell.contentView addSubview:heroimgview];
                        NSLog(@"the contentview %f", heroimgview.contentSize.width);
                        break;
                    }
                        
                    case 2:{
                        addview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 60)];
                        NSLog(@"Regualr price %lu and price %@", (unsigned long)regularprice.length, price);
                        if (![regularprice isEqualToString:price])  {
                            [self showspecialprice];
                        } else if (regularprice.length == 0) {
                            [self noshowspecialprice];
                        } else {
                            [self noshowspecialprice];
                        }
                        UILabel *iteminstock = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 60, 17)];
                        iteminstock.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
                        
                        if ([stock_status isEqualToString:@"instock"]) {
                            iteminstock.text = @"在庫";
                            iteminstock.textColor = [UIColor colorWithRed:0.66 green:0.72 blue:0.53 alpha:0.8];
                        } else {
                            iteminstock.text = @"售完";
                            iteminstock.textColor = [UIColor colorWithRed:0.73 green:0.18 blue:0.23 alpha:0.8];
                        }
                        [addview addSubview:iteminstock];
                        [cell.contentView addSubview:addview];
                        
                    }
                        break;
                }
                
            }
            if(indexPath.section == 0) {
                cell.userInteractionEnabled = YES;
            } else {
                cell.userInteractionEnabled = YES;
            }
        } else {
            if (indexPath.section == 2) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                switch (indexPath.row) {
                    case 0:
                    {
                        //cell.textLabel.text = @"描述";
                        
                        UILabel *toplable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, curwidth-20, 27)];
                        toplable.text = @"詳細資料";
                        
                        NSString *htmlstirng = productdescriptions;
                        htmlstirng = [htmlstirng stringByAppendingString:@"<style>body{font-family:HelveticaNeue-Light; font-size:17px; color: #8e8e93; text-align: right;}</style>"];
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlstirng dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, curwidth-40, 40)];
                        textview.userInteractionEnabled = NO;
                        textview.attributedText = attributedString;
                        textview.textAlignment = NSTextAlignmentCenter;
                        textviewframe = textview.frame;
                        textviewframe.size.height = [textview contentSize].height+50;
                        textview.frame = textviewframe;
                        [cell.contentView addSubview:toplable];
                        [cell.contentView addSubview:textview];
                    }
                        break;
                    default:
                        break;
                }
            } else if (indexPath.section == 1) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                switch (indexPath.row) {
                    case 0:
                        {
                            UILabel *toplable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, curwidth-20, 27)];
                            toplable.text = @"選擇種類";
                            variationsbuttonview = [[UIView alloc] init];
                            variationsbuttonview.frame = CGRectMake(5, 40, curwidth-10, optionareaheight);
                            [self showvariations:nil];
                            [cell.contentView addSubview:variationsbuttonview];
                            [cell.contentView addSubview:toplable];
                        }
                        break;
                        
                    default:
                        break;
                }
            }  else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                switch (indexPath.row) {
                    case 0:
                    {
                        UIView *addview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 70)];
                        
                        UILabel *producname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, curwidth-20, 50)];
                        producname.text = readtext;
                        producname.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
                        producname.textAlignment = NSTextAlignmentLeft;
                        producname.lineBreakMode = NSLineBreakByWordWrapping;
                        producname.numberOfLines = 2;
                        
                        CALayer *tlayer = [addview layer];
                        CALayer *topborder = [CALayer layer];
                        topborder.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor;
                        topborder.borderWidth = 1;
                        topborder.frame = CGRectMake(0, 1, tlayer.frame.size.width, 1);
                        [topborder setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4].CGColor];
                        UIImageView *ratingview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 97, 20)];
                        
                        ratingview.contentMode = UIViewContentModeScaleAspectFit;
                        switch ([productrating integerValue]) {
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
                        UILabel *noofrating_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 52, 97, 16)];
                        noofrating_label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
                        noofrating_label.textAlignment = NSTextAlignmentLeft;
                        if ([noofrating integerValue] == 0) {
                            noofrating_label.text = [NSString stringWithFormat:@"( %@ 評分)",[postid substringToIndex:2]];
                        } else {
                            noofrating_label.text = [NSString stringWithFormat:@"( %@ 評分)", noofrating];
                        }
                        
                        [ratingview setImage:ratingimage];
                        
                        [tlayer addSublayer:topborder];
                        [addview addSubview:noofrating_label];
                        [addview addSubview:ratingview];
                        [addview addSubview:producname];
                        [cell.contentView addSubview:addview];
                        break;
                    }
                        
                        
                    case 1:
                    {
                        
                        [heroimgview removeFromSuperview];
                        if(!galleryurl) {
                            heroimgview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
                            UIImageView *testview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
                            [testview sd_setImageWithURL:[NSURL URLWithString:mainimgurl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                            //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[productimg objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                            imagdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:mainimgurl]];
                            
                            testview.contentMode = UIViewContentModeScaleAspectFit;
                            testview.clipsToBounds = YES;
                            [heroimgview addSubview:testview];
                        } else {
                            if([galleryurl count] > 0) {
                                int i;
                                NSInteger noofpic = [galleryurl count];
                                heroimgview = [[UIScrollView alloc] init];
                                heroimgview.frame = CGRectMake(0, 0, curwidth, curwidth/4*3);
                                heroimgview.contentSize = CGSizeMake(curwidth*(noofpic+1), curwidth/4*3);
                                heroimgview.scrollEnabled = YES;
                                heroimgview.pagingEnabled = YES;
                                heroimgview.delegate = self;
                                heroimgview.clipsToBounds = YES;
                                heroimgview.backgroundColor = [UIColor whiteColor];
                                
                                UIImageView *testview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
                                [testview sd_setImageWithURL:[NSURL URLWithString:mainimgurl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                                //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[productimg objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                                imagdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:mainimgurl]];
                                
                                testview.contentMode = UIViewContentModeScaleAspectFit;
                                testview.clipsToBounds = YES;
                                [heroimgview addSubview:testview];
                                
                                for (i=0; i<[galleryurl count]; i++) {
                                    [self performSelectorOnMainThread:@selector(createview:) withObject:[NSString stringWithFormat:@"%d", i] waitUntilDone:YES];
                                }
                                //[self performSelector:@selector(createview:) withObject:[NSString stringWithFormat:@"%lu", (unsigned long)[galleryurl count]] afterDelay:0];
                            }
                        }
                        [cell.contentView addSubview:heroimgview];
                        NSLog(@"the contentview %f", heroimgview.contentSize.width);
                        break;
                    }
                        
                    case 2:{
                        addview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 60)];
                        NSLog(@"Regualr price %lu and price %@", (unsigned long)regularprice.length, price);
                        if (![regularprice isEqualToString:price])  {
                            [self showspecialprice];
                        } else if (regularprice.length == 0) {
                            [self noshowspecialprice];
                        } else {
                            [self noshowspecialprice];
                        }
                        UILabel *iteminstock = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 60, 17)];
                        iteminstock.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
                        
                        if ([stock_status isEqualToString:@"instock"]) {
                            iteminstock.text = @"在庫";
                            iteminstock.textColor = [UIColor colorWithRed:0.66 green:0.72 blue:0.53 alpha:0.8];
                        } else {
                            iteminstock.text = @"售完";
                            iteminstock.textColor = [UIColor colorWithRed:0.73 green:0.18 blue:0.23 alpha:0.8];
                        }
                        [addview addSubview:iteminstock];
                        [cell.contentView addSubview:addview];
                        
                    }
                        break;
                }
                
            }
            if(indexPath.section == 0) {
                cell.userInteractionEnabled = YES;
            } else {
                cell.userInteractionEnabled = YES;
            }
        }
        
        
    }
    
    return cell;
}
-(void)createview:(NSString*)sendervalue {
    
    NSInteger objinx = [sendervalue integerValue];
    NSLog(@"count %lu - %ld", (unsigned long)[galleryurl count], (long)objinx);
    UIImageView *testview = [[UIImageView alloc] initWithFrame:CGRectMake(curwidth*(objinx+1), 0, curwidth, curwidth/4*3)];
    [testview sd_setImageWithURL:[NSURL URLWithString:[galleryurl objectAtIndex:objinx]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[productimg objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    imagdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:mainimgurl]];
    
    testview.contentMode = UIViewContentModeScaleAspectFit;
    testview.clipsToBounds = YES;
    [heroimgview addSubview:testview];
}
-(void)showspecialprice {
    UILabel *regular_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110, 19)];
    regular_label.text = regularprice;
    regular_label.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *crosstitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"港幣 %.2f",[regularprice doubleValue]] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    regular_label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
    [regular_label adjustsFontSizeToFitWidth];
    [regular_label setAttributedText:crosstitle];
    
    UILabel *sale_label = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, 140, 21)];
    
    sale_label.text = [NSString stringWithFormat:@"港幣 %.2f", [price doubleValue]];
    sale_label.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    sale_label.textColor = [UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.8];
    [addview addSubview:sale_label];
    [addview addSubview:regular_label];
    UILabel *reduceprice = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 160, 17)];
    reduceprice.textAlignment =NSTextAlignmentLeft;
    reduceprice.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    double reductvalue = [regularprice doubleValue] - [price doubleValue];
    reduceprice.text = [NSString stringWithFormat:@"立即節省港幣 %.2f", reductvalue];
    reduceprice.textColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    [addview addSubview:reduceprice];
}
-(void)noshowspecialprice {
    
    UILabel *sale_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 21)];
    
    sale_label.text = [NSString stringWithFormat:@"港幣 %.2f", [price doubleValue]];
    sale_label.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    sale_label.textColor = [UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.8];
    [addview addSubview:sale_label];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 5)];
    customview.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];

    return customview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(havevariation == NO) {
        if(indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 70;
            } else if(indexPath.row == 2) {
                return 60;
            } else {
                return curwidth/4*3;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return textviewframe.size.height;
            } else {
                return 60;
            }
        } else {
            return 60;
        }
    } else {
        if(indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 70;
            } else if(indexPath.row == 2) {
                return 60;
            } else {
                return curwidth/4*3;
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                return textviewframe.size.height;
            } else {
                return 60;
            }
        } else {
            return optionareaheight;
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    } else {
        return 5.0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (havevariation == NO) {
        productdetailwebview = [self.storyboard instantiateViewControllerWithIdentifier:@"productwebview"];
        productdetailwebview.productid = postid;
        productdetailwebview.detailtitle = detailtitle;
        [self.navigationController pushViewController:productdetailwebview animated:YES];
        [maintableview deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        if (indexPath.section == 2) {
            productdetailwebview = [self.storyboard instantiateViewControllerWithIdentifier:@"productwebview"];
            productdetailwebview.productid = postid;
            productdetailwebview.detailtitle = detailtitle;
            [self.navigationController pushViewController:productdetailwebview animated:YES];
            [maintableview deselectRowAtIndexPath:indexPath animated:YES];
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
