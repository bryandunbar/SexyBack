//
//  ModalBackgroundView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/4/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

@IBDesignable class ModalBackgroundView: UIView {

    private var archView:ArchedView!
    private var maskLayer:CAShapeLayer?
    
    
    @IBInspectable var cornerRadius:CGFloat = 20.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var archHeight:CGFloat = 60.0 {
        didSet {
            archView?.archHeight = archHeight
            setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor(red: 39/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
    }
    
    @IBInspectable var archColor:UIColor! = UIColor(red: 37/255.0, green: 38/255.0, blue: 37/255.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if maskLayer == nil {
            maskLayer = CAShapeLayer()
            let path:CGPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius)).CGPath
            maskLayer?.path = path
            self.layer.mask = maskLayer
        }
        maskLayer!.frame = self.bounds
        
        // position archview
        var archViewRect:CGRect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: self.archHeight)
        if archView == nil {
            archView = ArchedView(frame: archViewRect)
            archView.archedViewSide = ArchedViewSide.Bottom
            archView.backgroundColor = self.archColor
            self.addSubview(archView)
            self.sendSubviewToBack(archView)
        } else {
            self.archView.frame = archViewRect
        }
    }
}
