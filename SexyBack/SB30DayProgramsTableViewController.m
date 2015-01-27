//
//  SB30DayProgramsTableViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 1/23/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SB30DayProgramsTableViewController.h"
#import "Constants.h"
#import "SB30DayContentViewController.h"
#import "SBProgramDetailTableViewController.h"

@interface SB30DayProgramsTableViewController ()
@property (nonatomic,strong) NSMutableArray *purchasedPrograms;
@property (nonatomic,strong) NSMutableArray *nonpurchasedPrograms;
@property (nonatomic,strong) NSNumberFormatter *numberFormmater;
@property (nonatomic,strong) PFObject *selectedProgram;
@end

@implementation SB30DayProgramsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberFormmater  = [[NSNumberFormatter alloc] init];
    self.numberFormmater.numberStyle = NSNumberFormatterCurrencyStyle;
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
-(void)viewWillAppear:(BOOL)animated {
    self.purchasedPrograms = STATE.user.parseUser[@"purchasedPrograms"];
    self.nonpurchasedPrograms = [NSMutableArray array];
    
    for (PFObject *program in STATE.programs) {
        BOOL found = NO;
        for (PFObject *testProgram in self.purchasedPrograms) {
            if ([testProgram.objectId isEqualToString:program.objectId]) {
                found = YES;
                break;
            }
        }
        if (!found)
            [self.nonpurchasedPrograms addObject:program];
    }
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 0;
    if (self.purchasedPrograms.count > 0) count++;
    if (self.nonpurchasedPrograms.count > 0) count++;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        return self.nonpurchasedPrograms.count;
    } else {
        if (section == 0)
            return self.purchasedPrograms.count;
        else
            return self.nonpurchasedPrograms.count;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        return @"Available Programs";
    } else {
        if (section == 0)
            return @"My Programs";
        else
            return @"Available Programs";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    BOOL purchased = NO;
    PFObject *program = nil;
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        program = self.nonpurchasedPrograms[indexPath.row];
    } else {
        if (indexPath.section == 0) {
            program = self.purchasedPrograms[indexPath.row];
            purchased = YES;
        }
        else
            program = self.nonpurchasedPrograms[indexPath.row];
    }
    
    cell.textLabel.text = program[@"name"];
    
    if (!purchased) {
        double price = [program[@"price"] doubleValue];
        if (price == 0)
            cell.detailTextLabel.text = @"Free!";
        else
            cell.detailTextLabel.text = [self.numberFormmater stringFromNumber:@(price)];
    } else {
        cell.detailTextLabel.text = nil;
    }
    NSLog(@"DetailLabel.text: %@", cell.detailTextLabel.text);
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedProgram = nil;
    BOOL unpurchased = YES;
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        self.selectedProgram = self.nonpurchasedPrograms[indexPath.row];
    } else {
        if (indexPath.section == 0) {
            self.selectedProgram = self.purchasedPrograms[indexPath.row];
            unpurchased = NO;
        } else {
            self.selectedProgram = self.nonpurchasedPrograms[indexPath.row];
        }
    }
    
    if (unpurchased) {
        [self performSegueWithIdentifier:@"programDetailSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"challengeSegue" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"programDetailSegue" isEqualToString:segue.identifier]) {
        SBProgramDetailTableViewController *destVc = (SBProgramDetailTableViewController*)segue.destinationViewController;
        destVc.program = self.selectedProgram;
    } else if ([@"challengeSegue" isEqualToString:segue.identifier]) {
        SB30DayContentViewController *destVc = (SB30DayContentViewController*)segue.destinationViewController;
        destVc.program = self.selectedProgram;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
