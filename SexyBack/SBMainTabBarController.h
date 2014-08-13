//
//  SBMainTabBarController.h
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBMainTabBarController : UITabBarController

-(void)launchAppForConsultant:(NSString*)consultantId;
-(void)launchSettings;
@end
