//
//  User.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "User.h"

@implementation User

-(id)init {
    self = [super init];
    if (self) {
        self.rewardsPoints = 10;
        self.frequencyGoalValue = 1;
        self.qualityGoalValue = 1;
    }
    return self;
}
#pragma mark -
#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.birthDay forKey:@"birthDay"];
    [aCoder encodeObject:self.maritalStatus forKey:@"maritalStatus"];
    [aCoder encodeObject:self.numberOfKids forKey:@"numberOfKids"];
    [aCoder encodeObject:self.annualIncome forKey:@"annualIncome"];
    [aCoder encodeObject:self.sexFrequencyGoal forKey:@"sexFrequencyGoal"];
    [aCoder encodeObject:self.sexQualityGoal forKey:@"sexQualityGoal"];
    [aCoder encodeObject:self.reminderFrequency forKey:@"reminderFrequency"];
    [aCoder encodeInt:self.rewardsPoints forKey:@"rewardsPoints"];
    [aCoder encodeInt:self.frequencyGoalValue forKey:@"frequencyGoalValue"];
    [aCoder encodeInt:self.qualityGoalValue forKey:@"qualityGoalValue"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    
    if (self = [self init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.birthDay = [aDecoder decodeObjectForKey:@"birthDay"];
        self.maritalStatus = [aDecoder decodeObjectForKey:@"maritalStatus"];
        self.numberOfKids = [aDecoder decodeObjectForKey:@"numberOfKids"];
        self.annualIncome = [aDecoder decodeObjectForKey:@"annualIncome"];
        self.sexFrequencyGoal = [aDecoder decodeObjectForKey:@"sexFrequencyGoal"];
        self.sexQualityGoal = [aDecoder decodeObjectForKey:@"sexQualityGoal"];
        self.reminderFrequency = [aDecoder decodeObjectForKey:@"reminderFrequency"];
        self.rewardsPoints = [aDecoder decodeIntForKey:@"rewardsPoints"];
        self.frequencyGoalValue = [aDecoder decodeIntForKey:@"frequencyGoalValue"];
        self.qualityGoalValue = [aDecoder decodeIntForKey:@"qualityGoalValue"];

    }
    return self;
    
}
@end
