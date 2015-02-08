//
//  AppState.h
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import <Parse/Parse.h>

@class AppState;

@interface AppStateManager : NSObject
@property (nonatomic,strong) AppState *appState;
@property (nonatomic,readonly) NSString *filePath;

-(BOOL)save;

@end


@interface AppState : NSObject <NSCoding>

@property (nonatomic) BOOL isFirstLaunch;
@property (nonatomic,strong) PFObject *consultant;
@property (nonatomic,strong) PFObject *party;
@property (nonatomic,strong) NSString *consultantId;
@property (nonatomic,strong) User *user;


@property (nonatomic,strong) NSArray *programs;
@property (nonatomic,strong) NSArray *challengeDays;

@property (nonatomic,readonly) NSArray *optionsNumberOfKids;
@property (nonatomic,readonly) NSArray *optionsAnnualIncome;
@property (nonatomic,readonly) NSArray *optionsMaritalStatus;
@property (nonatomic,readonly) NSArray *optionsReminderFrequency;
@property (nonatomic,readonly) NSArray *optionsSexQuality;
@property (nonatomic,readonly) NSArray *optionsSexFrequency;

@property (nonatomic,readonly) NSString *client;
@property (nonatomic,readonly) NSString *hotStuffUrl;


@property (nonatomic) int dareDay;
@property (nonatomic,readonly) PFObject *currentDare;


/** Double Dare Challenge **/
@property (nonatomic,strong) NSArray *doubleDareChallenges;

@end

