//
//  CheckBox.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

import QuartzCore

@IBDesignable public class CheckBox: UIControl, UIGestureRecognizerDelegate {

    private var borderLayer:CAShapeLayer?
    private var markLayer:CAShapeLayer?
    private var tapGestureRecognizer:UIGestureRecognizer!
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        setupTapGesture()
    }
    
    func setupTapGesture() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckBox.viewTapped(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer.delegate = self
    }
    
    // MARK: Actions
    func viewTapped(sender:UITapGestureRecognizer) {
        self.isChecked = !self.isChecked
    }
    

    // MARK: Properties
    override public var selected:Bool {
        get {
            return isChecked
        }
        set {
            isChecked = newValue
        }
    }
    
    @IBInspectable public var isChecked: Bool = false {
        didSet {
            sendActionsForControlEvents(UIControlEvents.ValueChanged)
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var strokeWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var inset:CGFloat = 5.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var markInset: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsLayout()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = UIColor.clearColor()

        if borderLayer == nil {
            borderLayer = CAShapeLayer()
            borderLayer!.fillColor = UIColor.clearColor().CGColor
            self.layer.addSublayer(borderLayer!)
            
        }
    
        // Place the border
        let bezierPath = UIBezierPath(rect: self.bounds.insetBy(dx: self.inset, dy: self.inset))
        borderLayer!.lineWidth = self.strokeWidth
        borderLayer!.strokeColor = self.tintColor.CGColor
        borderLayer!.path = bezierPath.CGPath
        //borderLayer!.frame = self.bounds
        
        // Draw the mark layer if checked
        if isChecked {
            if markLayer == nil {
                markLayer = CAShapeLayer()
                self.layer.addSublayer(markLayer!)
            }
            
            let bezierPath = UIBezierPath(rect: self.bounds.insetBy(dx: self.inset + self.markInset, dy: self.inset + self.markInset))
            markLayer!.fillColor = self.tintColor.CGColor
            markLayer!.path = bezierPath.CGPath
            markLayer?.hidden = false
        } else {
            markLayer?.hidden = true
        }
        
    }
    
}
