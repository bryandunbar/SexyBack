//
//  UIBorderedButton.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/1/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//
import UIKit

@IBDesignable class UIBorderedButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
    
    override var enabled:Bool {
        didSet {
            if enabled != oldValue {
                self.layer.borderColor = !enabled ? UIColor.lightGrayColor().CGColor : self.tintColor?.CGColor;
                setNeedsDisplay()
            }
        }
    }
    
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
    }
    
}
