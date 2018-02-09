//
//  SecondViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailViewController;
@class SubSecViewController;
@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSUserDefaults *standardUsers;
    CGFloat curwidth;
    CGFloat curheigh;
    UITableView *mainview;
    UIView *topview;
    ProductDetailViewController *productview;
    SubSecViewController *subsecview;
    NSMutableArray *catname;
    NSMutableArray *catnum;
    NSArray *showitem;
}


@end

