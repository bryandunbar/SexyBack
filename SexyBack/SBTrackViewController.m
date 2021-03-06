//
//  SBTrackViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBTrackViewController.h"
#import "SFGaugeView.h"
#import "Constants.h"
@interface SBTrackViewController ()

@property (weak, nonatomic) IBOutlet SFGaugeView *frequencyGauge;
@property (weak, nonatomic) IBOutlet SFGaugeView *qualityGauge;
@end

@implementation SBTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.frequencyGauge.minlevel = 1;
    self.frequencyGauge.maxlevel = 100;
    self.frequencyGauge.hideLevel = YES;
    self.frequencyGauge.needleColor = [UIColor colorWithRed:252/255.0 green:123/255.0 blue:188/255.0 alpha:1.0];
    //self.frequencyGauge.bgColor = [UIColor colorWithRed:52/255.0 green:129/255.0 blue:188/255.0 alpha:1.0];
    self.frequencyGauge.userInteractionEnabled = NO;
    
    self.qualityGauge.minlevel = 1;
    self.qualityGauge.maxlevel = 100;
    self.qualityGauge.hideLevel = YES;
    self.qualityGauge.needleColor = [UIColor colorWithRed:252/255.0 green:123/255.0 blue:188/255.0 alpha:1.0];
    //self.qualityGauge.bgColor = [UIColor colorWithRed:52/255.0 green:129/255.0 blue:188/255.0 alpha:1.0];
    self.qualityGauge.userInteractionEnabled = NO;
    

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.frequencyGauge.currentLevel = STATE.user.frequencyGoalValue;
    self.qualityGauge.currentLevel = STATE.user.qualityGoalValue;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToTrackViewController:(UIStoryboardSegue *)unwindSegue
{
}

@end
