//
//  WTCircleImageView.m
//  WalkingTour
//
//  Created by Bryan Dunbar on 10/14/14.
//  Copyright (c) 2014 Scripps Media, Inc. All rights reserved.
//

#import "WTCircleImageView.h"

@interface WTCircleImageView ()
@property (nonatomic,strong) CALayer *imageLayer;
@end

@implementation WTCircleImageView


-(void)setImage:(UIImage *)image {
   
    _image = image;
    [self updateLayerProperties];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    // Create the image layer
    if (!self.imageLayer) {
        
        // Mask the image to the circle
        CAShapeLayer *imageMaskLayer = [CAShapeLayer layer];
        UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        imageMaskLayer.path = innerPath.CGPath;
        imageMaskLayer.fillColor = [UIColor blackColor].CGColor;
        imageMaskLayer.frame = self.bounds;
        [self.layer addSublayer:imageMaskLayer];
        
        // Now create the image layer and apply the mask
        self.imageLayer = [CALayer layer];
        self.imageLayer.mask = imageMaskLayer;
        self.imageLayer.frame = self.bounds;
        self.imageLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        self.imageLayer.contentsGravity = kCAGravityResizeAspectFill;
        [self.layer addSublayer:self.imageLayer];
    }
    
    // Ensure everything is updated
    [self updateLayerProperties];
}

-(void)updateLayerProperties {
    if (self.imageLayer != nil) {
        if (self.image)
            self.imageLayer.contents = (__bridge id)(self.image.CGImage);
        else
            self.imageLayer.contents = nil;
    }
}


@end
