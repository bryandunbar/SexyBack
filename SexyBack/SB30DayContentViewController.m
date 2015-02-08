//
//  SB30DayContentViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 9/23/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SB30DayContentViewController.h"
#import "Constants.h"
#import "UIBorderedButton.h"
#import "SBDareHistoryTableViewController.h"
@interface SB30DayContentViewController ()

@property (weak, nonatomic) IBOutlet UIBorderedButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UILabel *dareLabel;
@property (weak, nonatomic) IBOutlet UITextView *howTextView;
@property (weak, nonatomic) IBOutlet UILabel *ptsLabel;
@property (weak, nonatomic) IBOutlet UITextView *whyTextView;
@end

@implementation SB30DayContentViewController
- (IBAction)completeTapped:(id)sender {
    [self challengeCompleted:YES];
}
- (IBAction)passedTapped:(id)sender {
    [self challengeCompleted:NO];
}

-(void)challengeCompleted:(BOOL)completed {
    
    if (completed) {
        STATE.user.rewardsPoints += [self.dare[@"points"] intValue];
    }
    
    // Save to the back end
    PFObject *obj = [PFObject objectWithClassName:@"ProgramProgress"];
    obj[@"user"] = STATE.user.parseUser;
    obj[@"program"] = self.program;
    obj[@"challenge"] = self.dare;
    obj[@"passed"] = [NSNumber numberWithBool:!completed];
    obj[@"completed"] = [NSNumber numberWithBool:completed];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        STATE.dareDay++;
        [self configureView];
        
    }];
    
}

-(PFObject*)dare {
    return STATE.currentDare;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

-(void)configureView {

    [UIView transitionWithView:self.view duration:.35f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.dareLabel.text = self.dare[@"dare"];
        self.howTextView.text = self.dare[@"how"];
        self.whyTextView.text = self.dare[@"why"];
        self.ptsLabel.text = [NSString stringWithFormat:@"%@ pts", self.dare[@"points"]];
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"dareHistorySegue"]) {
        SBDareHistoryTableViewController *vc = (SBDareHistoryTableViewController*)segue.destinationViewController;
        vc.program = self.program;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.howTextView sizeToFit];
        return self.howTextView.bounds.size.height + 30;
    } else if (indexPath.section == 1){
        [self.whyTextView sizeToFit];
        return self.whyTextView.bounds.size.height + 30;
    } else {
        return tableView.rowHeight;
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
