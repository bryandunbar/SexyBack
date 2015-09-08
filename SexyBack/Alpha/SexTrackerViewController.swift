//
//  SexTrackerViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class SexTrackerViewController: UIViewController {

    @IBOutlet var slider: FeatherSlider!
    @IBOutlet var goalLabael: UILabel!
    
    let menuTransitioningDelegate = SlidingOverlayTransitioningDelegate()
    let modalTransitioningDelegate = BouncyOverlayTransitioningDelegate()

    
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "weeklyEventCountUpdatedHandler", name: WeeklyEventCountUpdatedNotification, object: nil)
    }
    func unregisterForNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func weeklyEventCountUpdatedHandler() {
        if let user:SBUser = AppController.instance.user {
            slider.setValue(Float(user.weeklyEventCount), animated: true)
        }
    }
    deinit {
        unregisterForNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        configureView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        // Ask for sex goal if we havne't set it
        var user:SBUser? = AppController.instance.user
        if user == nil || user!.weeklySexGoal == 0 {
            self.performSegueWithIdentifier("goalModalSegue", sender: self)
        }
    }
    
    func configureView() {
        if let user = AppController.instance.user {
            self.goalLabael.text = String(format: "My Weekly Sex Goal: %dx", user.weeklySexGoal)
            self.slider.hidden = false
            self.slider.maximumValue = Float(user.weeklySexGoal)
            self.slider.value = Float(user.weeklyEventCount);
        } else {
            self.slider.hidden = true
            self.goalLabael.text = nil
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayMenuSegue" {
            let overlayVC = segue.destinationViewController as! UIViewController
            overlayVC.transitioningDelegate = menuTransitioningDelegate
            overlayVC.modalPresentationStyle = .Custom
            
        } else if segue.identifier == "goalModalSegue" {
            let overlayVC:GoalModalViewController = segue.destinationViewController as! GoalModalViewController
            overlayVC.transitioningDelegate = modalTransitioningDelegate
            overlayVC.modalPresentationStyle = .Custom
            overlayVC.dismissHandler = { (value:Int) in
                if let user = AppController.instance.user {
                    user.weeklySexGoal = value
                    self.configureView()
                    AppController.instance.save()
                }
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func trackEventTapped(sender: AnyObject) {
        
        if let user = AppController.instance.user {
            user.trackSexEvent({ (success:Bool, error:NSError?) -> Void in
            })
            
            // Move the slider
            var sliderVal:Float = self.slider!.value
            sliderVal = sliderVal + 1
            self.slider!.setValue(sliderVal, animated: true)

        }
        
    }
}
