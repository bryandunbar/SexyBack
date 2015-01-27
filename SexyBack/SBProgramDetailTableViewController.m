//
//  SBProgramDetailTableViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 1/23/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBProgramDetailTableViewController.h"
#import "Constants.h"
#import "SBVideoTableViewCell.h"

@interface SBProgramDetailTableViewController ()
@property (nonatomic,strong) NSString *videoUrl;
@end

@implementation SBProgramDetailTableViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoUrl = self.program[@"preview_video_url"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}
- (IBAction)buyNowTapped:(id)sender {
    
    NSString *message = nil;
    NSString *title = nil;
    double price = [self.program[@"price"] doubleValue];
    if (price == 0) {
        title = @"Congratulations!";
        message = @"You are on your way to getting your sexy back!";
    } else {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterCurrencyStyle;
        title = @"Confirm Purchase";
        message = [NSString stringWithFormat:@"Would you like to buy '%@' for '%@'?", self.program[@"name"],[nf stringFromNumber:@(price)] ];
    }

    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"No", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Ok", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   PFObject *user = STATE.user.parseUser;
                                   if (user[@"purchasedPrograms"] == nil) {
                                       user[@"purchasedPrograms"] = [NSMutableArray array];
                                   }
                                   [user[@"purchasedPrograms"] addObject:self.program];
                                   [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];

                                   
                               }];
    
    if (price > 0)[alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)return self.program[@"name"];
    return @"";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.videoUrl ? 3 : 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.videoUrl && indexPath.section == 1)
        return 200;
    else
        return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
            cell = [self descriptionCellForTableView:tableView atIndexPath:indexPath];
            break;
        case 1:
            cell = self.videoUrl ? [self videoCellForTableView:tableView atIndexPath:indexPath] : [self buttonCellForTableView:tableView atIndexPath:indexPath];
            break;
        case 2:
            cell = [self buttonCellForTableView:tableView atIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    return cell;
    
}

-(UITableViewCell*)descriptionCellForTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
    UILabel *descriptionLabel = (UILabel*)[cell viewWithTag:1000];
    descriptionLabel.text = self.program[@"description"];
    return cell;
}


-(UITableViewCell*)buttonCellForTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
    UIButton *button = (UIButton*)[cell viewWithTag:1000];
    [button addTarget:self action:@selector(buyNowTapped:) forControlEvents:UIControlEventTouchUpInside];
    double price = [self.program[@"price"] doubleValue];
    if (price == 0)
        [button setTitle:@"Get" forState:UIControlStateNormal];
    else {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterCurrencyStyle;
        [button setTitle:[NSString stringWithFormat:@"Buy Now = %@", [nf stringFromNumber:@(price)]] forState:UIControlStateNormal];
    }

    return cell;
    
}
-(UITableViewCell*)videoCellForTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    
    SBVideoTableViewCell *videoCell = (SBVideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    videoCell.videoUrl = self.videoUrl;
    return videoCell;    
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
