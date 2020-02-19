//
//  LoginViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2018/02/05.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;
@interface LoginViewController : UIViewController <UITextFieldDelegate, NSURLSessionDelegate> {
    IBOutlet UIButton *cancelbutton;
    CGFloat curwidth;
    CGFloat curheigh;
    IBOutlet UIButton *signinlabel;
    NSDictionary *jsonData;
    NSInteger success;
    WebViewController *webview;
    UIView *loadingview;
}
@property (retain, nonatomic) IBOutlet UITextField *Username;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UIButton *loginclick;
-(IBAction)loginclicked:(id)sender;
-(IBAction)backgroundclick:(id)sender;
@end
