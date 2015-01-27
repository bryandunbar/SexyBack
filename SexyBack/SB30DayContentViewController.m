//
//  SB30DayContentViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 9/23/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SB30DayContentViewController.h"
#import "Constants.h"

@interface SB30DayContentViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *completedSwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SB30DayContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    self.textView.text = self.challengeObj[@"desc"];
    [self.textView sizeToFit];
    self.navigationItem.title = [NSString stringWithFormat:@"Day %d", [self.challengeObj[@"day"] intValue]];
    
    // Did they complete this challenge?
    for (PFObject *completedChallenges in self.programProgress[@"completeChallenges"]) {
        if ([completedChallenges[@"day"] intValue] == [self.challengeObj[@"day"] intValue]) {
            self.completedSwitch.on = YES;
            break;
        }
    }
    
}

- (IBAction)switchSwitched:(UISwitch*)sender {
    
    
    if (!self.programProgress[@"completeChallenges"]) {
        self.programProgress[@"completeChallenges"] = [NSMutableArray array];
    }
    // Does it already exist in their completes?
    BOOL found = NO;
    id removeIt = nil;
    for (PFObject *challenge in self.programProgress[@"completeChallenges"]) {
        if ([challenge[@"day"] intValue] == [self.challengeObj[@"day"] intValue]) {
            found = YES;
            if (!sender.on) {
                removeIt = challenge;
            }
        }
    }
    
    if (!found && sender.on) {
        [self.programProgress[@"completeChallenges"] addObject:self.challengeObj];
    } else if (removeIt) {
        [self.programProgress[@"completeChallenges"] removeObject:removeIt];
    }
    
    [self.programProgress saveInBackground];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self.textView sizeToFit];
        return self.textView.bounds.size.height + 30;
    } else {
        return tableView.rowHeight;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return self.challengeObj[@"title"];
    } else {
        return [NSString stringWithFormat:@"Day %d", [self.challengeObj[@"day"] intValue]];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
