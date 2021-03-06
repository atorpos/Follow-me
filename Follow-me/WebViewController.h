//
//  WebViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 1/11/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate> {
    CGFloat curwidth;
    CGFloat curheigh;
    UIWebView *webview;
    UIActivityIndicatorView *activityView;
    IBOutlet UIButton *openinweb;
    IBOutlet UIButton *cancelbutton;
}
@property (copy) NSString *weblinkstring;
@property (copy) NSString *websetting;
@end
