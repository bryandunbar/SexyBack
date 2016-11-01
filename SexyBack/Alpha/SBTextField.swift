//
//  SBTextField.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/4/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class SBTextField: UITextField, UIDefaultAccessoryInputViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        let accView:UIDefaultAccessoryInputView = UIDefaultAccessoryInputView(hostView: self)
        accView.accessoryInputViewDelegate = self
        accView.showsNextPrev = false
        self.inputAccessoryView = accView
    }

    // MARK: UIDefaultAccessoryInputViewDelegate
    func nextPrevTapped(sender: UISegmentedControl!) {
        
    }
    func doneTapped(sender: UIDefaultAccessoryInputView!) {
        self.resignFirstResponder()
    }
}
