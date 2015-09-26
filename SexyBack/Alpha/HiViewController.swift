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
    
    @IBOutlet var archView: UIView!
    @IBOutlet var hiImage: UIImageView!
    
    @IBOutlet var ageRange: UIPickerField!
    @IBOutlet var gender: UIPickerField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var profileImageView: ProfileImageView!
    @IBOutlet var profileViewVerticalSpaceContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView!.delegate = self
        
        if AppController.instance.isOnboarded {
            
            if AppController.instance.openedFromNotificaion {
                self.performSegueWithIdentifier("challengeSegueNotAnimated", sender: self)
                AppController.instance.openedFromNotificaion = false
            } else {
                self.performSegueWithIdentifier("nextViewControllerNotAnimated", sender: self)
            }
        } else {
            configureDrawerFields()
            initDrawerViewLocation()
        }
    }
    
    func configureDrawerFields() {
        self.ageRange!.choices = ["","18-25", "26-35", "36-50", "Over 50"]
        self.ageRange!.hideOnSelection = true
        self.gender!.choices = ["", "Male", "Female"]
        self.gender!.hideOnSelection = true
    }
    
    func initDrawerViewLocation() {
        
        let height = self.view.bounds.height
        let constant:CGFloat = height - 125.0
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
                    let constant = self.hiImage.center.y - 40
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
    
    /// MARK: - Actions
    @IBAction func doneButtonTapped(sender: AnyObject) {

        // Don't show this screen anymore
        AppController.instance.isOnboarded = true
        
        // Store our user information
        let user:SBUser = SBUser()
        user.firstName = self.firstName.text
        user.gender = self.gender.text
        user.ageRange = self.ageRange.text
        user.profileImage = self.profileImageView.image
        AppController.instance.user = user
        
        self.performSegueWithIdentifier("nextViewControllerAnimated", sender: self)
        
    }
    /// MARK: - ProfileImageViewDelegate
    func presentingViewControllerForProfileImageView(view: ProfileImageView) -> UIViewController {
        return self
    }
    
}
