//
//  ProductDetailWebViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 1/29/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "ProductDetailWebViewController.h"

@interface ProductDetailWebViewController ()

@end

@implementation ProductDetailWebViewController
@synthesize detailtitle, productid, newscontents;
- (void)viewDidLoad {
    [super viewDidLoad];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    pageurl = @"https://www.follow-me.pro/mobileitemdispay.php";
    [self createUI];
}
-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"post id: %@", productid);
    
    self.navigationController.navigationBar.topItem.title = detailtitle;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.6]];
    [self performSelectorOnMainThread:@selector(getserverfile:) withObject:productid waitUntilDone:YES];
}
-(void)getserverfile:(NSString *)loadpage{
    NSString *sentoproustrting = [NSString stringWithFormat:@"pid=%@",loadpage];
    NSData *postdata = [sentoproustrting dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *stringlength = [NSString stringWithFormat:@"%lu", (unsigned long)[sentoproustrting length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:pageurl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:stringlength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postdata];
    [request setTimeoutInterval:10.0];
    [showcontentview loadRequest:request];
}
-(void)createUI {
    showcontentview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    
    [self.view addSubview:showcontentview];
    [self cartview];
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
    UIButton *passvalue = (UIButton *)sender;
    NSLog(@"%ld",(long)passvalue.tag);
    switch (passvalue.tag) {
        case 0:
            NSLog(@"select to cart");
            break;
        case 1:
            NSLog(@"slect to list");
            break;
        default:
            break;
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
