//
//  FeatherSlider.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class FeatherSlider: UISlider {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    
    
    func setup() {
        let image:UIImage = UIImage(named: "feather" )!
        let height:CGFloat = image.size.height
        let width:CGFloat = image.size.width
        self.setThumbImage(image.imageWithAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -1 * height + 10, right: 0)), forState: UIControlState.Normal)
        
        let trackImage:UIImage = UIImage(named: "sex-tracker-slider-track")!
        let expandingTrackImage:UIImage = trackImage.resizableImageWithCapInsets(UIEdgeInsets(top:0,left:5,bottom:0,right:0))
        self.setMaximumTrackImage(expandingTrackImage, forState: UIControlState.Normal)
        self.setMinimumTrackImage(expandingTrackImage, forState: UIControlState.Normal)
    }
    
//    override func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
//        let rect:CGRect = super.thumbRectForBounds(bounds, trackRect: rect, value: value)
//        
//        let xOffset:CGFloat = value > (self.maximumValue - self.minimumValue) / 2 ? 40 : -10
//        
//        return CGRect(x: rect.origin.x + xOffset, y: rect.origin.y - 20, width: rect.width, height: rect.height)
//    }
}
