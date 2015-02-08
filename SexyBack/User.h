//
//  User.h
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject <NSCoding>

@property (nonatomic,strong) NSString *parseObjectId;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDate *birthDay;

@property (nonatomic,strong) NSString *maritalStatus;
@property (nonatomic,strong) NSString *numberOfKids;
@property (nonatomic,strong) NSString *annualIncome;

@property (nonatomic,strong) NSString *sexFrequencyGoal;
@property (nonatomic,strong) NSString *sexQualityGoal;
@property (nonatomic,strong) NSString *reminderFrequency;


@property (nonatomic) int rewardsPoints;
@property (nonatomic) int frequencyGoalValue;
@property (nonatomic) int qualityGoalValue;

-(void)saveToParse;

@property (nonatomic,strong) PFObject *parseUser;
@property (nonatomic,strong) NSArray *programProgress;

@end
