//
//  SBAppDelegate.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBAppDelegate.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface SBAppDelegate()

@end


@implementation SBAppDelegate

-(AppStateManager*)stateManager {
    if (_stateManager == nil) {
        _stateManager = [[AppStateManager alloc] init];
    }
    return _stateManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Connect to Parse
    [Parse setApplicationId:@"GmQSc8VAYnlIGSPFp3JEr8Y8diHkmyIT7El8Kk6K"
                  clientKey:@"50MSq0xuEeO1AtZLeyt4ZqfFyZ6h2AXxCsldVTtg"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // Register for push
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    NSDictionary * navBarTitleTextAttributes =
  @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    
    [self.stateManager save];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.rootViewController launchAppForConsultant:@"q2ECPUF8oz"];
//    });
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.stateManager save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.stateManager save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self.rootViewController launchAppForConsultant:@"54321"];

    
    // Getting some points just for launching the app
    STATE.user.rewardsPoints += 5;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.stateManager save];
}


#pragma mark -
#pragma mark - Properties
-(SBMainTabBarController*)rootViewController {
    return (SBMainTabBarController*)self.window.rootViewController;
}

#pragma mark -
#pragma mark - Deep Links
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if (![url.scheme isEqualToString:@"sexyback"]) return NO;
    
	if ([url.host isEqualToString:@"consultant"]) {
        NSString *consultantId = [url pathComponents][1];
        [self.rootViewController launchAppForConsultant:consultantId];
        return YES;
	}
    
    return NO;
}

@end
