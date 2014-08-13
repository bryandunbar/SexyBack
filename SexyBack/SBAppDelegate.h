//
//  SBAppDelegate.h
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppState.h"
#import "SBMainTabBarController.h"

@interface SBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppStateManager *stateManager;
@property (nonatomic,readonly) SBMainTabBarController *rootViewController;

@end
