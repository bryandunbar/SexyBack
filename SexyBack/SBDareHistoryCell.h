//
//  SBDareHistoryCell.h
//  SexyBack
//
//  Created by Bryan Dunbar on 2/7/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SBDareHistoryCell : UITableViewCell

@property (nonatomic,strong) PFObject *dareProgress;

@end
