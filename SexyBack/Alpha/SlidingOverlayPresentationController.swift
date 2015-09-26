//
//  OverlayPresentationController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class SlidingOverlayPresentationController: UIPresentationController {
 
    let dimmingView = UIView()
    
    var overlayPercentage:CGFloat = 0.85 {
        didSet {
            
        }
    }
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        configureDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ context in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 1.0 // No way to animate
        }
    }

    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ context in
            self.dimmingView.alpha = 0.0
            }, completion: {
                context in
                self.dimmingView.removeFromSuperview()
            })
        }
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return true
    }
    
    override func  sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: floor(parentSize.width * self.overlayPercentage), height: parentSize.height)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        var presentedViewFrame:CGRect = CGRect()
        let containerBounds:CGRect = containerView!.bounds
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        //presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        return presentedViewFrame
    }
    
    // MARK: Dimming View
    func configureDimmingView() {
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dimmingViewTapped:")
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func dimmingViewTapped(sender:UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}
