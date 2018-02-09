//
//  SuccessViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2018/01/31.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : UIViewController {
    NSUserDefaults *defaults;
    CGFloat curwidth;
    CGFloat curheigh;
    NSArray *callbackarray;
}

@property (copy) NSString *responsevalue;
@property (copy) NSString *responsestring;

@end
