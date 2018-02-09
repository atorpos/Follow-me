//
//  NewsViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 11/23/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class NewsDetailViewController;
@interface NewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSUserDefaults *standardUsers;
    CGFloat curwidth;
    CGFloat curheigh;
    UITableView *mainview;
    NSString *jsonurl_str;
    NSString *readpage;
    NSString *readtext;
    NSString *stringID;
    NSString *fronttitle;
    NewsDetailViewController *newdetailview;
}
@property (retain) NSMutableArray *contentname;
@property (retain) NSMutableArray *contentdate;
@property (retain) NSMutableArray *contentid;
@property (retain) NSMutableArray *imgurl;

@end
