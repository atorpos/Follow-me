//
//  SettingViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2017/11/20.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class WebViewController;

@interface SettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    CGFloat curwidth;
    CGFloat curheigh;
    NSUserDefaults *standardUser;
    IBOutlet UIButton *logoutbutton;
    IBOutlet UIButton *registbutton;
    LoginViewController *loginview;
    WebViewController *webview;
}
@property (nonatomic, retain) IBOutlet UITableView *tableview;

@end
