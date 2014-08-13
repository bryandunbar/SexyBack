//
//  SBGoalsViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBGoalsViewController.h"
#import "UIPickerField.h"
#import "Constants.h"
@interface SBGoalsViewController ()
@property (weak, nonatomic) IBOutlet UIPickerField *pickReminderFrequency;
@property (weak, nonatomic) IBOutlet UIPickerField *pickSexQuality;
@property (weak, nonatomic) IBOutlet UIPickerField *pickSexFrequency;

@end

@implementation SBGoalsViewController

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
    // Do any additional setup after loading the view.
}

-(void)configureView {
    
    // Setup Fields
    self.pickReminderFrequency.choices = STATE.optionsReminderFrequency;
    self.pickReminderFrequency.selectedChoice = STATE.user.reminderFrequency;

    self.pickSexFrequency.choices = STATE.optionsSexFrequency;
    self.pickSexFrequency.selectedChoice = STATE.user.sexFrequencyGoal;

    self.pickSexQuality.choices = STATE.optionsSexQuality;
    self.pickSexQuality.selectedChoice = STATE.user.sexQualityGoal;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    STATE.user.reminderFrequency = self.pickReminderFrequency.selectedChoice;
    STATE.user.sexFrequencyGoal = self.pickSexFrequency.selectedChoice;
    STATE.user.sexQualityGoal = self.pickSexQuality.selectedChoice;
    [APP.stateManager save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
