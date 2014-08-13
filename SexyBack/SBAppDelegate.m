//
//  SBAppDelegate.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBAppDelegate.h"

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
    return YES;
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
    //[self.rootViewController launchAppForConsultant:@"12345"];
    [self.rootViewController launchSettings];
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
        NSLog(@"Launching for consultantId: %@", consultantId);
        [self.rootViewController launchAppForConsultant:consultantId];
        return YES;
	}
    
    return NO;
}

@end
