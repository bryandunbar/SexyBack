//
//  SBMainTabBarController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBMainTabBarController.h"
#import "Constants.h"

NSString * const LaunchedForConsultantSegue = @"launchForConsultantSegue";
NSString * const SettingsSegue = @"settingsSegue";

@interface SBMainTabBarController () {
    NSString *_consultantId;
}

@end

@implementation SBMainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToMainTabBarController:(UIStoryboardSegue *)unwindSegue
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)launchAppForConsultant:(NSString *)consultantId {
    _consultantId = consultantId;
    STATE.consultantId = consultantId;
    
    [self performSegueWithIdentifier:LaunchedForConsultantSegue sender:self];
}
-(void)launchSettings {
    [self performSegueWithIdentifier:SettingsSegue sender:self];
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
