//
//  SlidingOverlayTransitioningDelegate.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class SlidingOverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController,
        presentingViewController presenting: UIViewController?,
        sourceViewController source: UIViewController) -> UIPresentationController? {
            
            let presentationController = SlidingOverlayPresentationController(presentedViewController: presented,
                presentingViewController: presenting)
            presentationController.overlayPercentage = 0.95
            return presentationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
        
        let animationController = SlidingOverlayAnimator()
        animationController.isPresentation = true
        return animationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = SlidingOverlayAnimator()
        animationController.isPresentation = false
        return animationController

    }
}
