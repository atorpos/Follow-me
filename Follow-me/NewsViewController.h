//
//  NewsViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 11/23/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController {
    NSUserDefaults *standardUsers;
    CGFloat curwidth;
    CGFloat curheigh;
    UIScrollView *mainview;
    UIView *topview;
}

@end
