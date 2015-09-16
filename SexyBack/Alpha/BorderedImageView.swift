//
//  BorderedImageView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/1/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit


@IBDesignable class BorderedImageView: UIView {

    
    @IBInspectable var image:UIImage? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var imageInset:CGFloat = 5.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var imageLayer:CALayer?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = self.tintColor!.CGColor;
        
    }

    func updateLayerProperties() {
        if let imageLayer = self.imageLayer {
            if let image = self.image {
                imageLayer.contents = image.CGImage!
            } else {
                imageLayer.contents = nil
            }
        }
    }

    // MARK: Overrides
    override var tintColor:UIColor? {
        didSet {
            if tintColor != oldValue {
                self.layer.borderColor = tintColor?.CGColor
                setNeedsDisplay()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        
        if self.imageLayer == nil && self.image != nil {
            
            // Mask the image
            let imageMaskLayer = CAShapeLayer()
            let innerPath = UIBezierPath(roundedRect: self.bounds .rectByInsetting(dx: self.imageInset, dy: self.imageInset), byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius))
            imageMaskLayer.path = innerPath.CGPath
            imageMaskLayer.fillColor = UIColor.blackColor().CGColor
            imageMaskLayer.frame = self.bounds;
            self.layer.addSublayer(imageMaskLayer)
            
            // Now create the image layer and apply the mask
            self.imageLayer = CALayer()
            self.imageLayer?.mask = imageMaskLayer;
            self.imageLayer?.frame = self.bounds;
            self.imageLayer?.backgroundColor = UIColor(white: 0.8, alpha:1.0).CGColor
            self.imageLayer?.contentsGravity = kCAGravityResizeAspectFill;
            self.layer.addSublayer(self.imageLayer);
        } 
        
        updateLayerProperties()
    }
    
}
