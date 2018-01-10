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
#import <HealthKit/HealthKit.h>
#import "SBJson.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class], [STPAPIClient class]]];
    
    // TODO: Replace with your own test publishable key
    // TODO: DEBUG ONLY! Remove / conditionalize before launch
    [Stripe setDefaultPublishableKey:@"pk_live_W9DfRAqvXM0UV2KVnax2fCUd"];

    
    //initial_url = @"https://d3q3ok4iuja3c0.cloudfront.net/payload/initial_json.json";
    initial_url = @"https://s3.amazonaws.com/follow_me_news/payload/initial_json.json";
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
