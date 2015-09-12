//
//  SexRankView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/8/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

@IBDesignable class SexRankView: UIView {

    @IBOutlet var listButton: UIButton!
    @IBOutlet private var textBorderView: UIView!
    @IBOutlet private var rankLabel: UILabel!
    @IBOutlet private var rankDetailLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageBackgroundView: UIView!
    
    
    @IBInspectable var rankText:String? = "Rank" {
        didSet {
            rankLabel.text = rankText
        }
    }
    
    @IBInspectable var rankDetailText:String? = "Rank Detail" {
        didSet {
            rankDetailLabel.text = rankDetailText
        }
    }
    
    @IBInspectable var image:UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.backgroundColor = UIColor.clearColor()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        textBorderView.layer.cornerRadius = 5.0
        imageBackgroundView.layer.cornerRadius = 5.0
        
        addSubview(view)
        
    }

    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SexRankView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    // MARK: Data
    func updateRank(user:SBUser) {
        
        if let rank:SexRank = SexRankController.sharedInstance.getRank(user) {
        
            self.rankText = rank.rankText
            self.rankDetailText = rank.rankDetail
            self.image = rank.rankImage
        } else {
            self.rankText = nil
            self.rankDetailText = nil
            self.image = nil
        }
    }
}
