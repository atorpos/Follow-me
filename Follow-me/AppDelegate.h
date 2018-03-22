//
//  AppDelegate.h
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Firebase.h"

@import FirebaseCore;
@import FirebaseAnalytics;
@import FirebaseInstanceID;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *initial_url;
    NSUserDefaults *standarddefs;
    NSDictionary *json;
}

@property (strong, nonatomic) UIWindow *window;


@end

