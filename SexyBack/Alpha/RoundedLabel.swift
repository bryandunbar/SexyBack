//
//  RoundedLabel.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 10/26/15.
//  Copyright © 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius;
    }
    
    @IBInspectable var cornerRadius:CGFloat = 5.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.cornerRadius
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
}
