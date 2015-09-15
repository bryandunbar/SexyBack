//
//  BaseSexyBackViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

let DisplayMenuSegueIdentifier = "displayMenuSegue"

class BaseSexyBackViewController: UIViewController, MenuViewControllerDelegate {

    let menuTransitioningDelegate = SlidingOverlayTransitioningDelegate()
    var myMenuItemType:MenuItemType!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DisplayMenuSegueIdentifier {
            let overlayVC = segue.destinationViewController as! MenuViewController
            overlayVC.transitioningDelegate = menuTransitioningDelegate
            overlayVC.modalPresentationStyle = .Custom
            overlayVC.delegate = self
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
        }
        // TODO: handle other cases
    }

}
