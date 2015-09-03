//
//  HiViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/1/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class HiViewController: UIViewController, ProfileImageViewDelegate{

    @IBOutlet var sexyBackLogo: UIImageView!
    
    @IBOutlet var hiImage: UIImageView!
    
    @IBOutlet var profileImageView: ProfileImageView!
    @IBOutlet var profileViewVerticalSpaceContraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView!.delegate = self
        initDrawerViewLocation()
    }
    
    func initDrawerViewLocation() {
        
        let height = self.view.bounds.height
        let constant:CGFloat = height - 100.0
        self.profileViewVerticalSpaceContraint.constant = constant
        self.view.layoutIfNeeded()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        runOnboardingAnimations()
    }
    
    func runOnboardingAnimations() {
        
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            self.sexyBackLogo.alpha = 0.0
            }) { (completed: Bool) -> Void in
            
            UIView.animateWithDuration(
                1.5, animations: { () -> Void in

                    // Show the "Hi" image
                    self.hiImage.alpha = 1.0
            })
                
            UIView.animateWithDuration(
                    0.5, animations: { () -> Void in

                    // Move arch view to middle of the "Hi" Image
                    let constant = self.hiImage.center.y - 20
                    self.profileViewVerticalSpaceContraint.constant = constant
                    self.view.layoutIfNeeded()
            })
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK - ProfileImageViewDelegate
    func presentingViewControllerForProfileImageView(view: ProfileImageView) -> UIViewController {
        return self
    }
    
}
