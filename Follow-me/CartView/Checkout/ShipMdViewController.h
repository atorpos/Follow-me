//
//  ShipMdViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipMdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *shippingmethod;
    CGFloat curwidth;
    CGFloat curheigh;
    NSUserDefaults *standarddefault;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end
