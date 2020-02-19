//
//  WebViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 1/11/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize websetting, weblinkstring;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"%@", weblinkstring);
    cancelbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelbutton.frame = CGRectMake(curwidth-60, 60, 30, 30);
    [cancelbutton setTitle:@"" forState:UIControlStateNormal];
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelbutton addTarget:self action:@selector(cancelpage:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *cancelimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage *cancelimg = [UIImage imageNamed:@"close"];
    [cancelimgview setImage:cancelimg];
    
    [cancelbutton addSubview:cancelimgview];
    
    
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    
    
    
    NSURL *url = [NSURL URLWithString:weblinkstring];
    NSURLRequest *requesturl = [NSURLRequest requestWithURL:url];
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 52, curwidth, curheigh-52)];
    [webview loadRequest:requesturl];
    webview.delegate = self;
    if ([websetting isEqualToString:@"social"]) {
        openinweb = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        openinweb.frame = CGRectMake(10, 22, 100, 30);
        [openinweb setTitle:@"Open in Web" forState:UIControlStateNormal];
        openinweb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [openinweb addTarget:self action:@selector(openweb:) forControlEvents:UIControlEventTouchUpInside];
        webview.scrollView.scrollEnabled = YES;
        webview.scrollView.bounces = YES;
        [self.view addSubview:openinweb];
    } else {
        webview.scrollView.scrollEnabled = YES;
        webview.scrollView.bounces = YES;
    }
    
    [self.view addSubview:webview];
    [self.view addSubview:cancelbutton];
    
    [self.view addSubview:activityView];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [activityView startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityView setHidden:YES];
}
-(IBAction)cancelpage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)openweb:(id)sender {
    NSURL *url = [NSURL URLWithString:weblinkstring];
    //[[UIApplication sharedApplication] openURL:url];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
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

