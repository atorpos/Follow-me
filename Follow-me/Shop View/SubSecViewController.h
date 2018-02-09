//
//  SubSecViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2018/01/22.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class ProductDetailViewController;
@interface SubSecViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSString *readtext;
    NSString *readpage;
    NSString *countarray;
    UITableView *mainview;
    ProductDetailViewController *productview;
    CGFloat curwidth;
    CGFloat curheigh;
    UIImage *ratingimage;
    UILabel *regularlabel;
}
@property (copy) NSString *catnum;
@property (copy) NSString *catname;
@property (retain) NSMutableArray *productnamearray;
@property (retain) NSMutableArray *stockstatus;
@property (retain) NSMutableArray *regularprice;
@property (retain) NSMutableArray *saleprice;
@property (retain) NSMutableArray *tecrating;
@property (retain) NSMutableArray *imgurl;
@property (retain) NSMutableArray *productid;
@end
