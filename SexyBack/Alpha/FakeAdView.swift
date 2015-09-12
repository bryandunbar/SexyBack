//
//  FakeAdView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/8/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

@IBDesignable class FakeAdView: UIView {

    private var _border:CAShapeLayer!
    private var label:UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        configureTextLabel()
        _border = CAShapeLayer()
        _border.strokeColor = UIColor.darkGrayColor().CGColor;
        _border.fillColor = nil;
        _border.lineDashPattern = [4, 2];
        self.layer.addSublayer(_border)
    }
    
    func configureTextLabel() {
        let rect:CGRect = self.bounds.rectByInsetting(dx: 5, dy: 5)
        self.label = UILabel(frame: rect)
        self.label.textAlignment = NSTextAlignment.Center
        self.label.textColor = UIColor.lightGrayColor()
        self.label.font = UIFont.systemFontOfSize(10)
        self.label.text = "Advertisement"
        self.label.userInteractionEnabled = true
        self.label.numberOfLines = 0
        
        // Constrain
        self.label.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.label.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.addSubview(self.label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _border.path = UIBezierPath(rect: self.bounds).CGPath
        _border.frame = self.bounds
        self.label.frame = self.bounds
    }


}
