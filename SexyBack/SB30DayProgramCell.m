//
//  SB30DayProgramCell.m
//  SexyBack
//
//  Created by Bryan Dunbar on 2/5/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SB30DayProgramCell.h"
#import "WTCircleImageView.h"
@interface SB30DayProgramCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet WTCircleImageView *circleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonatomic,strong) NSNumberFormatter *numberFormmater;

@end

@implementation SB30DayProgramCell

-(NSNumberFormatter*)numberFormmater {
    if (!_numberFormmater) {
        _numberFormmater  = [[NSNumberFormatter alloc] init];
        _numberFormmater.numberStyle = NSNumberFormatterCurrencyStyle;

    }
    return _numberFormmater;
}

-(void)setProgram:(PFObject *)program {
    _program = program;
    self.circleImageView.image = [UIImage imageNamed:_program[@"previewImageName"]];
    self.titleLabel.text = _program[@"name"];
    self.categoryLabel.text = _program[@"category"];
    [self updatePriceLabel];
}

-(void)setPurchased:(BOOL)purchased {
    _purchased = purchased;
    [self updatePriceLabel];
}

-(void)updatePriceLabel {
    
    
    if (!_purchased) {
        double price = [self.program[@"price"] doubleValue];
        if (price == 0)
            self.priceLabel.text = @"Free!";
        else
            self.priceLabel.text = [self.numberFormmater stringFromNumber:@(price)];
    } else {
        self.priceLabel.text = nil;
    }
    
}

-(void)prepareForReuse {
    
    [super prepareForReuse];
    self.priceLabel.text = nil;
    self.circleImageView.image = nil;
    self.titleLabel.text = nil;
    self.categoryLabel.text = nil;
    
}

@end
