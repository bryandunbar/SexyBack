//
//  SB30DayProgramCell.h
//  SexyBack
//
//  Created by Bryan Dunbar on 2/5/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SB30DayProgramCell : UITableViewCell

@property (nonatomic,strong) PFObject *program;
@property (nonatomic) BOOL purchased;
@end
