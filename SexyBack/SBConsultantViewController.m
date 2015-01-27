//
//  SBConsultantViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBConsultantViewController.h"
#import "UIDateField.h"
#import "UIDefaultAccessoryInputView.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface SBConsultantViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblConsultantName;
@property (weak, nonatomic) IBOutlet UITextField *partyId;
@property (weak, nonatomic) IBOutlet UIDateField *partyDateField;
@end

@implementation SBConsultantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

-(void)configureView {
    
    self.lblConsultantName.text = @"";
    
    
    [self nameForConsultantId:STATE.consultantId];
    
    // Configure the date field
    self.partyDateField.dateMode = UIDatePickerModeDate;
    self.partyDateField.dateStyle = NSDateFormatterShortStyle;
    self.partyDateField.timeStyle = NSDateFormatterNoStyle;
    
    UIDefaultAccessoryInputView *accInputView = [[UIDefaultAccessoryInputView alloc] initWithHostView:self.partyDateField];
    accInputView.showsNextPrev = NO;
    self.partyDateField.inputAccessoryView = accInputView;
    
    self.partyId.inputAccessoryView = [[UIDefaultAccessoryInputView alloc] initWithHostView:self.partyId];

    [self.partyDateField setSelectedDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takeQuizTapped:(id)sender {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Party"];
    [query whereKey:@"partyId" equalTo:@([self.partyId.text intValue])];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            STATE.party = objects[0];
            
            // Subscribe to notifications for this party
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:STATE.party.objectId forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
    }];
    
}

-(void)nameForConsultantId:(NSString*)consultantId {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Consultant"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"username" equalTo:consultantId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            STATE.consultant = objects[0];
            self.lblConsultantName.text = STATE.consultant[@"name"];
        }
    }];
    
}

@end
