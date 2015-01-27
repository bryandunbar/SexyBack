//
//  SB30DayPageViewController.h
//  SexyBack
//
//  Created by Bryan Dunbar on 9/23/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SB30DayPageViewController : UIPageViewController

@property (nonatomic,strong) PFObject *program;

@end
