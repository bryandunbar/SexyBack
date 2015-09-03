//
//  RoundedCornerView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/1/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

@IBDesignable class RoundedCornerView: UIView {
    
    @IBInspectable var corners:UIRectCorner = UIRectCorner.TopLeft | UIRectCorner.TopRight {
        didSet {
            self.roundCorners(self.corners, radius: self.cornerRadius)
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 3.0 {
        didSet {
            self.roundCorners(self.corners, radius: self.cornerRadius)
        }
    }    
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

