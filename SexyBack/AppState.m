//
//  AppState.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//


#import "AppState.h"
@implementation AppStateManager
@synthesize appState=_appState;

-(AppState*)appState {
    if (_appState == nil) {
        _appState = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
        
        if (!_appState) {
            _appState = [[AppState alloc] init];
        }
    }
    return _appState;
}
-(BOOL)save {
    return [NSKeyedArchiver archiveRootObject:self.appState toFile:self.filePath];
}

-(NSString*)filePath {
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_State.plist", appName]];
}


@end

@interface AppState ()
@end


@implementation AppState
@synthesize optionsNumberOfKids=_optionsNumberOfKids;
@synthesize optionsMaritalStatus=_optionsMaritalStatus;
@synthesize optionsAnnualIncome=_optionsAnnualIncome;
@synthesize optionsReminderFrequency=_optionsReminderFrequency;
@synthesize optionsSexFrequency=_optionsSexFrequency;
@synthesize optionsSexQuality=_optionsSexQuality;
-(id)init {
    if (self = [super init]) {
        _isFirstLaunch = YES;
    }
    return self;
}

-(User*)user {
    if (!_user) {
        _user = [[User alloc] init];
    }
    return _user;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.consultantId forKey:@"consultantId"];
    [aCoder encodeObject:self.user forKey:@"user"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.consultantId = [aDecoder decodeObjectForKey:@"consultantId"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.isFirstLaunch = NO;
    }
    return self;
}

-(NSArray*)optionsAnnualIncome {
    if (!_optionsAnnualIncome) {
        _optionsAnnualIncome = @[@"", @"Under $75k", @"$75k - $150k", @"150k+"];
    }
    return _optionsAnnualIncome;
}

-(NSArray*)optionsMaritalStatus {
    if (!_optionsMaritalStatus) {
        _optionsMaritalStatus = @[@"", @"Married", @"Committed Relationship", @"Single", @"Divorced"];
    }
    return _optionsMaritalStatus;
}

-(NSArray*)optionsNumberOfKids {
    if (!_optionsNumberOfKids) {
        _optionsNumberOfKids = @[@"", @"None", @"2-3", @"4 or more"];
    }
    return _optionsNumberOfKids;
}

-(NSArray*)optionsReminderFrequency {
    if (!_optionsReminderFrequency) {
        _optionsReminderFrequency = @[@"", @"Three Times a Day", @"Daily", @"Weekly"];
    }
    return _optionsReminderFrequency;
}

-(NSArray*)optionsSexQuality {
    if (!_optionsSexQuality) {
        _optionsSexQuality = @[@"", @"Nice but forgettable", @"Great Performance", @"Off the Charts"];
    }
    return _optionsSexQuality;
}

-(NSArray*)optionsSexFrequency {
    if (!_optionsSexFrequency) {
        _optionsSexFrequency = @[@"", @"Three or more per week", @"Weekly", @"Two or more per month"];
    }
    return _optionsSexFrequency;
}

@end

