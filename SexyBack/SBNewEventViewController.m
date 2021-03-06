//
//  SBNewEventViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/13/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBNewEventViewController.h"
#import "SFGaugeView.h"
#import "Constants.h"
#import <Parse/Parse.h>
@interface SBNewEventViewController ()
@property (weak, nonatomic) IBOutlet SFGaugeView *gaugeView;

@end

@implementation SBNewEventViewController
- (IBAction)trackItTapped:(id)sender {
    
    STATE.user.frequencyGoalValue++;
    STATE.user.qualityGoalValue += self.gaugeView.currentLevel;
    [APP.stateManager save];
    
    PFObject *sexEvent = [PFObject objectWithClassName:@"SexEvent"];
    sexEvent[@"user"] = [PFObject objectWithoutDataWithClassName:@"UserProfile" objectId:STATE.user.parseObjectId];
    sexEvent[@"quality"] = @(self.gaugeView.currentLevel);
    

    [sexEvent saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

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
    
    self.gaugeView.minImage = @"minImage";
    self.gaugeView.maxImage = @"maxImage";
    self.gaugeView.autoAdjustImageColors = YES;
    self.gaugeView.currentLevel = 5;
    self.gaugeView.minlevel = 1;
    self.gaugeView.maxlevel = 10;
    self.gaugeView.needleColor = [UIColor colorWithRed:252/255.0 green:123/255.0 blue:188/255.0 alpha:1.0];

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
