import UIKit

class BouncyOverlayPresentationController: UIPresentationController {
   let dimmingView = UIView()
  
  override init(presentedViewController: UIViewController, presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
  }
  
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView!.bounds
    dimmingView.alpha = 0.0
    containerView!.insertSubview(dimmingView, atIndex: 0)
    
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
      context in
      self.dimmingView.alpha = 1.0
    }, completion: nil)
  }
  
  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
      context in
      self.dimmingView.alpha = 0.0
    }, completion: {
      context in
      self.dimmingView.removeFromSuperview()
    })
  }
  
  override func frameOfPresentedViewInContainerView() -> CGRect {
    let size:CGSize = self.presentedViewController.preferredContentSize
    let containerSize:CGSize = containerView!.bounds.size
    
    let x:CGFloat = (containerSize.width - size.width) / 2
    let y:CGFloat = (containerSize.height - size.height) / 2
    let rect:CGRect = CGRect(x: x, y: y, width: size.width, height: size.height)
    return rect
  }
  
  override func containerViewWillLayoutSubviews() {
    dimmingView.frame = containerView!.bounds
    presentedView()!.frame = frameOfPresentedViewInContainerView()
  }
}
