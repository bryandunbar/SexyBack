//
//  SB30DayContentViewController.h
//  SexyBack
//
//  Created by Bryan Dunbar on 9/23/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SB30DayContentViewController : UITableViewController

@property NSUInteger pageIndex;
@property PFObject *program;
@property PFObject *challengeObj;
@property PFObject *programProgress;
@end
