//
//  SBProgramDetailTableViewController.h
//  SexyBack
//
//  Created by Bryan Dunbar on 1/23/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SBProgramDetailTableViewController : UITableViewController

@property (nonatomic,strong) PFObject *program;
@end
