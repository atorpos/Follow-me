//
//  NewsDetailViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 1/11/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController<UIWebViewDelegate>
{
    UIView *showpicview;
    UIWebView *showcontentview;
    UIView *footeractionview;
    CGFloat curwidth;
    CGFloat curheigh;
    NSString *pageurl;
    UIActivityIndicatorView *activityView;
}
@property (copy) NSString *detailtitle;
@property (copy) NSString *productid;
@property (copy) NSString *newscontents;

@end

