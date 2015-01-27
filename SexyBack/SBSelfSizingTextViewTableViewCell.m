//
//  SBSelfSizingTextViewTableViewCell.m
//  SexyBack
//
//  Created by Bryan Dunbar on 1/23/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBSelfSizingTextViewTableViewCell.h"

@implementation SBSelfSizingTextViewTableViewCell

-(void)awakeFromNib {
    [self setupConstraints];
}

-(void)setupConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-textView-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"textView":self.textView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-textView-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(self.textView)]];
}

@end
