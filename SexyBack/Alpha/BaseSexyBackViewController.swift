//
//  BaseSexyBackViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

let MenuViewControllerIdentifier = "MenuViewControllerIdentifier"

class BaseSexyBackViewController: UIViewController, MenuViewControllerDelegate {

    let menuTransitioningDelegate = SlidingOverlayTransitioningDelegate()
    var myMenuItemType:MenuItemType!
    
    lazy var menuViewController:MenuViewController = {
        [unowned self] in
        
        var vc:MenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier(MenuViewControllerIdentifier) as! MenuViewController
        vc.delegate = self
        vc.transitioningDelegate = self.menuTransitioningDelegate
        vc.modalPresentationStyle = .Custom
        return vc
    }()
    
    lazy var hamburgerMenu:UIButton = {
        [unowned self] in
        
        var button:UIButton = UIButton(frame: CGRect(x: 16, y: 20, width: 44.0, height: 44.0))
        button.setImage(UIImage(named: "hamburger"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: "hamburgerTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1.0, constant: -16))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 44.0))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 44.0))
        return button
    }()

    var showsHamburgerMenu:Bool = true {
    
        didSet {
            toggleHamburgerMenuVisibility()
        }
    }
    
    func toggleHamburgerMenuVisibility() {
        hamburgerMenu.hidden = !showsHamburgerMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toggleHamburgerMenuVisibility()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func hamburgerTapped() {
        self.presentViewController(self.menuViewController, animated: true) { () -> Void in
            
        }
    }
    

    
    // MARK: MenuControllerDelegate
    func itemSelected(controller: MenuViewController, menuItem: MenuItem) {
        assert(myMenuItemType != nil, "You must set myMenuItem on all SexyBackViewControllers")
        
        if myMenuItemType == menuItem.type {
            return // Selected the current one
        }
        
        // Dismiss ourself
        controller.dismissViewControllerAnimated(true, completion:nil)

        // Show the selected
        if let segueIdentifer = menuItem.segueIdentifier {
            self.performSegueWithIdentifier(segueIdentifer, sender: self)
        } else if let viewControllerIdentifer = menuItem.viewControllerIdentifier {
            let vc:UIViewController = (self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifer))!
            if let navigationController = self.navigationController {
                navigationController.popViewControllerAnimated(false)
                navigationController.pushViewController(vc, animated: false)
            }
            
        }
        // TODO: handle other cases
    }

}
