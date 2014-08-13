//
//  User.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "User.h"

@implementation User


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

    }
    return self;
    
}
@end
