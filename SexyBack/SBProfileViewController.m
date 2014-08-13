//
//  SBProfileViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/12/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBProfileViewController.h"
#import "UIDateField.h"
#import "UIPickerField.h"
#import "Constants.h"

@interface SBProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIDateField *dateBirthday;
@property (weak, nonatomic) IBOutlet UIPickerField *pickMaritalStatus;
@property (weak, nonatomic) IBOutlet UIPickerField *pickNumberOfKids;
@property (weak, nonatomic) IBOutlet UIPickerField *pickAnnualIncome;
@end

@implementation SBProfileViewController

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
    // Do any additional setup after loading the view.
    
    [self configureView];
}

-(void)configureView {
    
    // Setup fields
    self.dateBirthday.dateMode = UIDatePickerModeDate;
    self.dateBirthday.dateStyle = NSDateFormatterShortStyle;
    self.dateBirthday.timeStyle = NSDateFormatterNoStyle;
    self.dateBirthday.delegate = self;
    
    // TODO: Load data from profile
    if (STATE.user.birthDay)
        [self.dateBirthday setSelectedDate:STATE.user.birthDay];
    self.txtName.text = STATE.user.name;
    self.txtEmail.text = STATE.user.email;
    
    
    self.pickAnnualIncome.choices = STATE.optionsAnnualIncome;
    self.pickMaritalStatus.choices = STATE.optionsMaritalStatus;
    self.pickNumberOfKids.choices = STATE.optionsNumberOfKids;
    
    self.pickMaritalStatus.selectedChoice = STATE.user.maritalStatus;
    self.pickAnnualIncome.selectedChoice = STATE.user.annualIncome;
    self.pickNumberOfKids.selectedChoice = STATE.user.numberOfKids;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    STATE.user.name = self.txtName.text;
    STATE.user.email = self.txtEmail.text;
    STATE.user.birthDay = self.dateBirthday.picker.date;
    STATE.user.maritalStatus = self.pickMaritalStatus.text;
    STATE.user.annualIncome = self.pickAnnualIncome.text;
    STATE.user.numberOfKids = self.pickNumberOfKids.text;
    
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


-(void)dateChanged:(UIDatePicker *)dateField {
    [self.dateBirthday setSelectedDate:dateField.date];
}

@end
