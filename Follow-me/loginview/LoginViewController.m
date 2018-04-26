//
//  LoginViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2018/02/05.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize Username, textPassword, loginclick;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    //UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDidHide:)];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login"]];
    backgroundView.frame = self.view.bounds;
    
    UIImageView *logoview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo.png"]];
    logoview.frame = CGRectMake(curwidth/2-100, 30, 200, 80);
    logoview.contentMode = UIViewContentModeScaleAspectFill;
    logoview.clipsToBounds = YES;
    [backgroundView addSubview:logoview];
    
    cancelbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelbutton.frame = CGRectMake(curwidth-60, 60, 30, 30);
    [cancelbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelbutton addTarget:self action:@selector(cancelpage:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *cancelimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage *cancelimg = [UIImage imageNamed:@"close"];
    [cancelimgview setImage:cancelimg];
    
    [cancelbutton addSubview:cancelimgview];
    signinlabel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    signinlabel.frame = CGRectMake(5, 3*curheigh/4, curwidth-10, 40);
    [signinlabel setTitle:@"sign up for free" forState:UIControlStateNormal];
    [signinlabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signinlabel addTarget:self action:@selector(webview:) forControlEvents:UIControlEventTouchUpInside];
    
    Username = [[UITextField alloc] initWithFrame:CGRectMake(10, curheigh/4, curwidth-20, 40)];
    Username.borderStyle = UITextGranularityLine;
    Username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    Username.placeholder = @"用戶名稱";
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, 40, curwidth-30, 0.5f);
    bottomBorder.backgroundColor = [UIColor greenColor].CGColor;
    [Username.layer addSublayer:bottomBorder];
    
    textPassword = [[UITextField alloc] initWithFrame:CGRectMake(10, curheigh/4+42, curwidth-20, 40)];
    textPassword.secureTextEntry = YES;
    textPassword.borderStyle = UITextGranularityLine;
    textPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textPassword.placeholder = @"密碼";
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0, 40, curwidth-30, 0.5f);
    bottomBorder2.backgroundColor = [UIColor greenColor].CGColor;
    [textPassword.layer addSublayer:bottomBorder2];
    
    
    self.loginclick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginclick.frame = CGRectMake(8, curheigh/4+104, curwidth-16, 40);
    [[self.loginclick layer] setBorderWidth:0.5f];
    [[self.loginclick layer] setCornerRadius:8.0f];
    
    [[self.loginclick layer] setMasksToBounds:YES];
    [[self.loginclick layer] setBorderColor:[UIColor greenColor].CGColor];
    [self.loginclick setTitle:@"登入" forState:UIControlStateNormal];
    [self.loginclick setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginclick addTarget:self action:@selector(loginclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *forgetpassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgetpassword.frame = CGRectMake(10, curheigh/4+150, curwidth-20, 40);
    [forgetpassword setTitle:@"忘記密碼" forState:UIControlStateNormal];
    [forgetpassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetpassword addTarget:self action:@selector(forgetpassword:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:cancelbutton];
    [self.view addSubview:self.loginclick];
    [self.view addSubview:textPassword];
    [self.view addSubview:Username];
    [self.view addSubview:signinlabel];
    [self.view addSubview:forgetpassword];
    [self.view addGestureRecognizer:tap];
    //[self.view addSubview:navbar];
}
-(void)keyboardDidHide:(NSNotification *) notif {
    [textPassword resignFirstResponder];
    [Username resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)webview:(id)sender {
    //mainController = (ViewController *)self.parentViewController;
    webview = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    webview.weblinkstring = @"https://www.follow-me.pro/weblogin.php";
    [self presentViewController:webview animated:NO completion:nil];
}
-(IBAction)forgetpassword:(id)sender {
    webview = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    webview.weblinkstring = @"https://www.follow-me.pro/?page_id=9&lost-password&v=5995289c850f";
    [self presentViewController:webview animated:NO completion:nil];
}
-(IBAction)cancelpage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)alertStatus:(NSString *)msg :(NSString *)title {
    UIAlertController *alercontroller = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertaction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alercontroller addAction:alertaction];
    
    [self presentViewController:alercontroller animated:YES completion:nil];
    
}
-(IBAction)loginclicked:(id)sender{
    NSLog(@"login clicked");
    loadingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curheigh, curheigh)];
    loadingview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:loadingview];
    @try {
        if([[textPassword text] isEqualToString:@""] || [[Username text] isEqualToString:@""]) {
            [loadingview removeFromSuperview];
            [self alertStatus:@"Please enter both Username and Password" :@"Login Failed!"];
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&passwd=%@",[Username text],[textPassword text]];
            NSLog(@"Post data: %@", post);
            NSUserDefaults *standarddefault = [NSUserDefaults standardUserDefaults];
            NSURL *url = [NSURL URLWithString:@"https://www.follow-me.pro/wploginaccess.php"];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            [request setTimeoutInterval:60.0];
            [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            //since NSURLConnection has been despeated in iOS9 NSURLConnection swap to NSURLSession
            //First part
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            //Second part
            NSMutableURLRequest *postrequest = [[NSMutableURLRequest alloc] initWithURL:url];
            postrequest.HTTPMethod = @"POST";
            //Third part
            [postrequest setHTTPMethod:@"POST"];
            [postrequest setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLSessionDataTask *datatask = [session dataTaskWithRequest:postrequest completionHandler:^(NSData *data, NSURLResponse *URLrespose, NSError *error) {
                //handel responser here
                if (!error) {
                    NSLog(@"success");
                    NSString *responsedata = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                    NSLog(@"response ==> %@", responsedata);
                    SBJsonParser *jsonParser = [SBJsonParser new];
                    self->jsonData = (NSDictionary *) [jsonParser objectWithString:responsedata error:nil];
                    NSLog(@"%@", self->jsonData);
                    self->success = [(NSNumber *) [self->jsonData objectForKey:@"logresponse"] integerValue];
                    NSLog(@"%ld",(long)self->success);
                    if (self->success == 1) {
                        NSLog(@"Login Succes");
                        [standarddefault setObject:[self->jsonData objectForKey:@"user_login"] forKey:@"username"];
                        [standarddefault setObject:[self->jsonData objectForKey:@"display_name"] forKey:@"display_name"];
                        [standarddefault setObject:[self->jsonData objectForKey:@"ID"] forKey:@"user_ID"];
                        [standarddefault setObject:[self->jsonData objectForKey:@"user_email"] forKey:@"useremail"];
                        //[self alertStatus:@"Login successful" :@"Login Good!"];
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }else {
                        NSLog(@"errorlog");
                        [self performSelectorOnMainThread:@selector(releaseview:) withObject:nil waitUntilDone:YES];
                    }
                }
            }];
            [datatask resume];
            if (datatask.state == NSURLSessionTaskStateCompleted) {
                NSLog(@"compalacted nsurlsession");
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        if (success == 1) {
            NSLog(@"Login Succes");
            [self alertStatus:@"Login successful" :@"Login Good!"];
        }else {
            NSLog(@"error ");
            NSString *error_msg = @"Username and Password is incorrect";
            [self alertStatus:error_msg :@"Login Failed!"];
        }
        
    }
}
-(IBAction)releaseview:(id)sender{
    NSLog(@"release log");
    [loadingview removeFromSuperview];
    [self alertStatus:@"Login error" :@"Username and Password incorrect"];
}
-(IBAction)backgroundclick:(id)sender{
    [Username resignFirstResponder];
}
-(IBAction)textFieldDidEndEditing:(UITextField *)textField {
    [Username resignFirstResponder];
    [textPassword resignFirstResponder];
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

