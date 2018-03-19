//
//  AppDelegate.m
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Stripe/Stripe.h>
//#import <HealthKit/HealthKit.h>
#import "SBJson.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UIApplicationDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class], [STPAPIClient class]]];
    NSString * language = [[NSLocale preferredLanguages] firstObject];
    //[self registerForRemoteNotifications]; //for the remote notification
    //
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
    
    // TODO: Replace with your own test publishable key
    // TODO: DEBUG ONLY! Remove / conditionalize before launch
    [Stripe setDefaultPublishableKey:@"pk_live_W9DfRAqvXM0UV2KVnax2fCUd"]; //testapi pk_test_uxUuoLZuOXfqprqOntgKspYl liveapi pk_live_W9DfRAqvXM0UV2KVnax2fCUd
    
    standarddefs = [NSUserDefaults standardUserDefaults];
    [standarddefs setObject:language forKey:@"systemlanguage"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //initial_url = @"https://d3q3ok4iuja3c0.cloudfront.net/payload/initial_json.json";
    initial_url = @"https://s3.amazonaws.com/follow_me_news/payload/initial_json.json";
    NSURL *url = [NSURL URLWithString:initial_url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *urlsession = [NSURLSession sharedSession];
    
    if([urlsession dataTaskWithRequest:request]) {
        NSData *urlData_fav = [NSData dataWithContentsOfURL:url];
        NSString *filepath_fav = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"initialjson.json"];
        [urlData_fav writeToFile:filepath_fav atomically:YES];
    }
    NSString *cat_string = @"https://www.follow-me.pro/parsejson_cat.php";
    NSURL *cat_url = [NSURL URLWithString:cat_string];
    NSURLRequest *cat_request = [[NSURLRequest alloc] initWithURL:cat_url];
    NSURLSession *cat_session = [NSURLSession sharedSession];
    
    if ([cat_session dataTaskWithRequest:cat_request]) {
        NSData *catData_set = [NSData dataWithContentsOfURL:cat_url];
        NSString *filepath_cat = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"catjson.json"];
        [catData_set writeToFile:filepath_cat atomically:YES];
    }
    
    
    //NSURL *url = [NSURL URLWithString:initial_url];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //NSURLSession *urlsession = [NSURLSession sharedSession];
    //if([urlsession dataTaskWithRequest:request]) {
    //    NSError *error;
    //    NSData *urlData_fav = [NSData dataWithContentsOfURL:url];
    //    json = [NSJSONSerialization JSONObjectWithData:urlData_fav options:kNilOptions error:&error];
    //    NSLog(@"%@-%lu", [json objectForKey:@"name"],[[json objectForKey:@"front_image_local"] count]); //READ INITIAL JSON FILE, IT CAN UPDATE IT AUTOMATICAL AFTERWARE
    //}
    
    
    return YES;
}
/*
- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Code for old versions
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
}
*/
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    if ([[standarddefs objectForKey:@"chooseitemid"] count] != 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[standarddefs objectForKey:@"chooseitemid"] count];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[standarddefs objectForKey:@"chooseitemid"] count] != 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[standarddefs objectForKey:@"chooseitemid"] count];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([[standarddefs objectForKey:@"chooseitemid"] count] != 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[standarddefs objectForKey:@"chooseitemid"] count];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [standarddefs setObject:token forKey:@"devicetoken"];
    if (![standarddefs objectForKey:@"readtoken"]) {
        [self senttoken];
    }
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"recived the notification");
}
-(void)senttoken{
    NSString *posttoken = [NSString stringWithFormat:@"token=%@", [standarddefs objectForKey:@"devicetoken"]];
    NSData *postdata = [posttoken dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *stringlength = [NSString stringWithFormat:@"%lu", (unsigned long)[posttoken length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *qrcodequery = @"https://www.follow-me.info/access/getoken.php";
    [request setURL:[NSURL URLWithString:qrcodequery]];
    [request setHTTPMethod:@"POST"];
    [request setValue:stringlength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postdata];
    [request setTimeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response &&! error) {
            NSString *readtext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"QR %@", readtext);
            if ([readtext isEqualToString:@"success"]) {
                NSLog(@"success");
                [standarddefs setObject:@"1" forKey:@"readtoken"];
            } else {
                NSLog(@"no value");
            }
        } else {
        }
    }];
    
    [task resume];
}


@end
