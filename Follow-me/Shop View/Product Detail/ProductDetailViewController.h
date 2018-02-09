//
//  ProductDetailViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 1/11/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class ProductDetailWebViewController;
@interface ProductDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *maintableview;
    CGFloat curwidth;
    CGFloat curheigh;
    IBOutlet UIButton *buybutton;
    IBOutlet UIBarButtonItem *buynow;
    NSUserDefaults *defaults;
    CGRect textviewframe;
    NSString *readtext;
    NSString *mainimgurl;
    NSArray *galleryurl;
    NSString *productdescriptions;
    NSString *stocks;
    NSString *productweight;
    NSString *productlength;
    NSString *productwidth;
    NSString *productheight;
    NSString *productsdk;
    NSString *stock_status;
    NSString *productrating;
    NSString *noofrating;
    UIImage *ratingimage;
    UIView *addview;
    NSData *imagdata;
    ProductDetailWebViewController *productdetailwebview;
}

@property (copy) NSString *detailtitle;
@property (copy) NSString *postid;
@property (copy) NSString *postcontent;
@property (copy) NSString *price;
@property (copy) NSString *regularprice;
@property (strong, nonatomic) UIActivityViewController *activityViewController;
@end
