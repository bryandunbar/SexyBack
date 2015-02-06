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
#import "UIBorderedButton.h"
@interface SBProgramDetailTableViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIBorderedButton *buyButton;
@property (nonatomic,strong) CAShapeLayer *headerMaskLayer;
@end

#define kTableHeaderHeight 200
#define kTableHeaderCutAway 40
@implementation SBProgramDetailTableViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoUrl = self.program[@"preview_video_url"];
    self.titleLabel.text = self.program[@"name"];
    self.headerImageView.image = [UIImage imageNamed:self.program[@"previewImageName"]];

    [self configureBuyButton];
    [self configureStretchyHeader];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)configureStretchyHeader {
    self.headerView = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil; // Steal the ref and add it as a subview
    [self.tableView addSubview:self.headerView];

    // Move the tableview's content down
    self.tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kTableHeaderHeight);
    
    // Configure the mask to cut the corner out
    self.headerMaskLayer = [CAShapeLayer layer];
    self.headerMaskLayer.fillColor = [UIColor blackColor].CGColor;
    self.headerImageView.layer.mask = self.headerMaskLayer;
    
    
    // Kick of first update
    [self updateHeaderView];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}
-(void)updateHeaderView {
    
    // Grow the image as the user pulls down
    CGRect headerRect = CGRectMake(0, -kTableHeaderHeight, self.tableView.bounds.size.width, kTableHeaderHeight);
    if (self.tableView.contentOffset.y < -kTableHeaderHeight) {
        headerRect.origin.y = self.tableView.contentOffset.y;
        headerRect.size.height = -self.tableView.contentOffset.y;
    }
    self.headerView.frame = headerRect;
    
    // Update the mask layer
    // Create the UIBezierPath for mask, we want to show through the bottom left corner for the
    // button
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(headerRect.size.width, 0)];
    [path addLineToPoint:CGPointMake(headerRect.size.width, headerRect.size.height)];
    [path addLineToPoint:CGPointMake(0, headerRect.size.height - kTableHeaderCutAway)];
    self.headerMaskLayer.path = path.CGPath;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.videoUrl ? 2 : 1;
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
            cell = [self videoCellForTableView:tableView atIndexPath:indexPath];
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

-(void)configureBuyButton {

    
    double price = [self.program[@"price"] doubleValue];
    if (price == 0)
        [self.buyButton setTitle:@"Get" forState:UIControlStateNormal];
    else {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterCurrencyStyle;
        [self.buyButton setTitle:[NSString stringWithFormat:@"%@", [nf stringFromNumber:@(price)]] forState:UIControlStateNormal];
    }

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
