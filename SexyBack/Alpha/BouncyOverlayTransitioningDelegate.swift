import UIKit

class BouncyOverlayTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
  
  func presentationControllerForPresentedViewController(presented: UIViewController,
                        presentingViewController presenting: UIViewController,
                        sourceViewController source: UIViewController) -> UIPresentationController? {
    
    return BouncyOverlayPresentationController(presentedViewController: presented,
                                         presentingViewController: presenting)
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
    return BouncyViewControllerAnimator()
  }
  
}
