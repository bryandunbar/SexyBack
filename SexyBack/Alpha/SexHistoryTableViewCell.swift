//
//  SexHistoryTableViewCell.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/11/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit
import Parse

class SexHistoryTableViewCell: UITableViewCell {

    @IBOutlet var imageBorderView: UIView! {
        didSet {
            imageBorderView.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet var rankImageView: UIImageView!
    @IBOutlet var rankTextLabel: UILabel!
    @IBOutlet var goalTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
