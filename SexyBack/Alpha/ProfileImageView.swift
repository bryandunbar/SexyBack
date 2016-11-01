//
//  ProfileImageView.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/1/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

@objc protocol ProfileImageViewDelegate : NSObjectProtocol {
    
    optional func pickImageTapped(view:ProfileImageView)
    
    /// Must return a view controller for which we can present the image picker dialog
    func presentingViewControllerForProfileImageView(view:ProfileImageView) -> UIViewController
}

@IBDesignable class ProfileImageView: UIView, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBInspectable var text:String = "Tap to Add Profile Image" {
        didSet {
            self.label?.text = text
            setNeedsLayout()
        }
    }
    
    @IBInspectable var image:UIImage? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBOutlet var delegate:ProfileImageViewDelegate?

    private var label:UILabel!
    private var imageLayer:CALayer?
    private var tapGestureRecognizer:UITapGestureRecognizer!
    
    private let imagePicker = UIImagePickerController()
    
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
        
        configureTextLabel()
        configureTapGestureRecognizer()
        configureImagePicker()

    }

    func updateLayerProperties() {
        if let imageLayer = self.imageLayer {
            if let image = self.image {
                imageLayer.contents = image.CGImage!
                self.label.hidden = true
            } else {
                imageLayer.contents = nil
                self.label.hidden = false
            }
        }
    }

    func configureImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
    }
    
    func configureTextLabel() {
        let rect:CGRect = self.bounds.insetBy(dx: 5, dy: 5)
        self.label = UILabel(frame: rect)
        self.label.textAlignment = NSTextAlignment.Center
        self.label.textColor = UIColor.lightGrayColor()
        self.label.font = UIFont.systemFontOfSize(12)
        self.label.text = self.text
        self.label.userInteractionEnabled = true
        self.label.numberOfLines = 0
        
        // Constrain
        self.label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.label.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self.label)
    }
    
    func configureTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileImageView.viewTapped(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer.delegate = self
    }
    
    // MARK: Actions
    func viewTapped(sender:UITapGestureRecognizer) {
        delegate?.pickImageTapped?(self)
        delegate?.presentingViewControllerForProfileImageView(self).presentViewController(imagePicker, animated: true, completion: { () -> Void in
            
        })
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
            let innerPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius))
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
            self.layer.addSublayer(self.imageLayer!);
        } 
        
        updateLayerProperties()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
        }
        
        delegate?.presentingViewControllerForProfileImageView(self).dismissViewControllerAnimated(true, completion: nil)
    }

}
