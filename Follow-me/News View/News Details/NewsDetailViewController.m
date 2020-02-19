//
//  NewsDetailViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 1/11/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end


@implementation NewsDetailViewController
@synthesize detailtitle, productid, newscontents;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    pageurl = @"https://www.follow-me.info/mobiledisplay.php";
    [self createUI];
}
-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"post id: %@", productid);
    
    self.navigationController.navigationBar.topItem.title = detailtitle;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.92 green:0.33 blue:0.34 alpha:0.6]];
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
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
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

@end
