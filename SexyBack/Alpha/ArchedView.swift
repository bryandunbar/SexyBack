//
//  RoundedCornerView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/1/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

enum ArchedViewSide:Int {
    case Top = 1, Left, Bottom, Right
}

@IBDesignable class ArchedView: UIView {
    
    var maskLayer:CAShapeLayer?
    
    var archedViewSide:ArchedViewSide = .Top {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var side:Int = ArchedViewSide.Top.rawValue {
        didSet {
            self.maskLayer = nil
            archedViewSide = ArchedViewSide(rawValue: side)!
            setNeedsLayout()
        }
    }
    
    @IBInspectable var archHeight:CGFloat = 60.0 {
        didSet {
            self.maskLayer = nil
            setNeedsLayout()
        }
    }
    
    func calculateMaskPath() -> CGPathRef {
        let path:UIBezierPath = UIBezierPath()
        
        if archedViewSide == ArchedViewSide.Top {
            path.moveToPoint(CGPoint(x: self.bounds.minX, y:self.archHeight))
            path.addQuadCurveToPoint(CGPoint(x: self.bounds.maxX, y:self.archHeight), controlPoint: CGPoint(x:self.bounds.midX, y:self.bounds.minY))
            path.addLineToPoint(CGPoint(x:self.bounds.maxX, y:self.bounds.maxY))
            path.addLineToPoint(CGPoint(x:self.bounds.minX, y:self.bounds.maxY))
            path.addLineToPoint(CGPoint(x:self.bounds.minX, y:self.archHeight))
        } else if archedViewSide == ArchedViewSide.Right {
            path.moveToPoint(CGPoint(x: self.bounds.maxX - self.archHeight, y:self.bounds.minY))
            path.addQuadCurveToPoint(CGPoint(x: self.bounds.maxX - self.archHeight, y:self.bounds.maxY), controlPoint: CGPoint(x:self.bounds.maxX, y:self.bounds.midY))
            path.addLineToPoint(CGPoint(x:self.bounds.minX, y:self.bounds.maxY))
            path.addLineToPoint(CGPoint(x:self.bounds.minX, y:self.bounds.minY))
            path.addLineToPoint(CGPoint(x:self.bounds.maxX - self.archHeight, y:self.bounds.minY))
        } else if archedViewSide == ArchedViewSide.Bottom {
            path.moveToPoint(CGPoint(x: self.bounds.minX, y:self.bounds.maxY - self.archHeight))
            path.addQuadCurveToPoint(CGPoint(x: self.bounds.maxX, y:self.bounds.maxY - self.archHeight), controlPoint: CGPoint(x:self.bounds.midX, y:self.bounds.maxY))
            path.addLineToPoint(CGPoint(x:self.bounds.maxX, y:self.bounds.minY))
            path.addLineToPoint(CGPoint(x:self.bounds.minX, y:self.bounds.minY))
            path.addLineToPoint(CGPoint(x:self.bounds.minX, y:self.archHeight))
        }
        return path.CGPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path:CGPathRef = calculateMaskPath()
        if (maskLayer == nil) {
            maskLayer = CAShapeLayer()
            maskLayer?.path = path
            self.layer.mask = maskLayer
        }

        // Update the path
        maskLayer!.path = path
        maskLayer!.frame = self.bounds
        
    }
}
