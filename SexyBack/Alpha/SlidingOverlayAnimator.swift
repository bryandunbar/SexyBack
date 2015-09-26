//
//  SlidingOverlayAnimator.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class SlidingOverlayAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    var isPresentation:Bool = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        let fromVC:UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView:UIView = fromVC.view
        let toVC:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView:UIView = toVC.view
        
        if isPresentation {
            transitionContext.containerView()!.addSubview(toView)
        }
        
        let animatingVC:UIViewController = isPresentation ? toVC : fromVC
        let animatingView:UIView = animatingVC.view
        
        let appearedFrame:CGRect = transitionContext.finalFrameForViewController(animatingVC)
        var dismissedFrame:CGRect = appearedFrame
        dismissedFrame.origin.x -= dismissedFrame.size.width
        
        let initialFrame:CGRect = isPresentation ? dismissedFrame : appearedFrame
        let finalFrame:CGRect = isPresentation ? appearedFrame : dismissedFrame
        
        animatingView.frame = initialFrame
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 300.0, initialSpringVelocity: 5.0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: { () -> Void in
            animatingView.frame = finalFrame
        }) { (Bool) -> Void in
            if !self.isPresentation {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
    
    }

}
