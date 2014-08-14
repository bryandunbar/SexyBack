//
//  SBRewardsViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/13/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBRewardsViewController.h"
#import "SFGaugeView.h"
#import "Constants.h"

@interface SBRewardsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblRewards;

@property (weak, nonatomic) IBOutlet SFGaugeView *gaugeView;
@end

@implementation SBRewardsViewController

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
    
    self.gaugeView.minlevel = 1;
    self.gaugeView.maxlevel = 400;
    self.gaugeView.hideLevel = YES;
    self.gaugeView.userInteractionEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    int rewards = STATE.user.rewardsPoints;
    self.gaugeView.currentLevel = STATE.user.rewardsPoints;
    self.lblRewards.text = [NSString stringWithFormat:@"%d", STATE.user.rewardsPoints];
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
