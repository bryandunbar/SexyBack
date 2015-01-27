//
//  User.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>
#import "Constants.h"

@implementation User

-(id)init {
    self = [super init];
    if (self) {
        self.rewardsPoints = 10;
        self.frequencyGoalValue = 1;
        self.qualityGoalValue = 1;
        self.parseUser = [PFObject objectWithClassName:@"UserProfile"];
        
    }
    return self;
}

-(void)saveToParse {
    
    if (self.parseObjectId) {
        PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
        [query includeKey:@"purchasedPrograms"];
        [query getObjectInBackgroundWithId:self.parseObjectId block:^(PFObject *object, NSError *error) {
            self.parseUser = object;
            [self setUserFields:object];
            [object saveInBackground];
        }];
    } else {
         PFObject *parseUser = [PFObject objectWithClassName:@"UserProfile"];
        [self setUserFields:parseUser];
        [parseUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                _parseObjectId = parseUser.objectId;

                // Add the user id as a channel
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addUniqueObject:self.parseObjectId forKey:@"channels"];
                [currentInstallation saveInBackground];
            }

        }];
    }
}

-(void)setUserFields:(PFObject*)parseUser {

    if (self.name)
        parseUser[@"name"] = self.name;
    
    if (self.email)
        parseUser[@"email"] = self.email;
    
    if (self.birthDay)
        parseUser[@"birthday"] = self.birthDay;
    
    if (self.maritalStatus)
        parseUser[@"maritalStatus"] = self.maritalStatus;
    
    if (self.numberOfKids)
        parseUser[@"numberOfKids"] = self.numberOfKids;
    
    if (self.sexFrequencyGoal)
        parseUser[@"sexFrequencyGoal"] = self.sexFrequencyGoal;
    
    if (self.sexQualityGoal)
        parseUser[@"sexQualityGoal"] = self.sexQualityGoal;
    
    if (self.annualIncome)
        parseUser[@"annualIncome"] = self.annualIncome;
    
    if (self.reminderFrequency)
        parseUser[@"reminderFrequency"] = self.reminderFrequency;
    
    parseUser[@"rewardsPoints"] = @(self.rewardsPoints);
    parseUser[@"frequencyGoalValue"] = @(self.frequencyGoalValue);
    parseUser[@"qualityGoalValue"] = @(self.qualityGoalValue);
    

    if (STATE.party)
        parseUser[@"party"] = STATE.party;
    
    if (STATE.consultant)
        parseUser[@"consultant"] = STATE.consultant;
    
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
    [aCoder encodeObject:self.parseObjectId forKey:@"parseObjectId"];
    
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
        self.parseObjectId = [aDecoder decodeObjectForKey:@"parseObjectId"];
    }
    return self;
    
}
@end
