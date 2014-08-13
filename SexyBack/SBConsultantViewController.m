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

@interface SBConsultantViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblConsultantName;
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
    
    self.lblConsultantName.text = [self nameForConsultantId:STATE.consultantId];
    
    
    // Configure the date field
    self.partyDateField.dateMode = UIDatePickerModeDate;
    self.partyDateField.dateStyle = NSDateFormatterShortStyle;
    self.partyDateField.timeStyle = NSDateFormatterNoStyle;
    
    UIDefaultAccessoryInputView *accInputView = [[UIDefaultAccessoryInputView alloc] initWithHostView:self.partyDateField];
    accInputView.showsNextPrev = NO;
    self.partyDateField.inputAccessoryView = accInputView;

    [self.partyDateField setSelectedDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takeQuizTapped:(id)sender {
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

-(NSString*)nameForConsultantId:(NSString*)consultantId {
    if ([consultantId isEqualToString:@"12345"]) {
        return @"Mary Pater";
    } else if ([consultantId isEqualToString:@"54321"]) {
        return @"Valerie Norvell";
    } else {
        return @"Some Consultant";
    }
}

@end
