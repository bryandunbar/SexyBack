//
//  SBDareHistoryCell.m
//  SexyBack
//
//  Created by Bryan Dunbar on 2/7/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBDareHistoryCell.h"

@interface SBDareHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *passCompleteImageView;

@end
@implementation SBDareHistoryCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setDareProgress:(PFObject *)dareProgress {
    
    _dareProgress = dareProgress;
    self.nameLabel.text = _dareProgress[@"challenge"][@"dare"];
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:_dareProgress.createdAt  dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    if ([_dareProgress[@"passed"] boolValue]) {
        self.passCompleteImageView.image = [UIImage imageNamed:@"23-circle-no"];
    } else {
        self.passCompleteImageView.image = [UIImage imageNamed:@"19-circle-check"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
    self.nameLabel.text = nil;
    self.dateLabel.text = nil;
    self.passCompleteImageView.image = nil;
}

@end
