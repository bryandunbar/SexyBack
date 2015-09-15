//
//  SexTrackerViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class SexTrackerViewController: BaseSexyBackViewController {

    @IBOutlet var slider: FeatherSlider!
    @IBOutlet var goalLabael: UILabel!
    @IBOutlet var rankView: SexRankView!
    
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
             configureView()
        }
    }
    deinit {
        unregisterForNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMenuItemType = MenuItemType.Tracker
        
        registerForNotifications()
        configureView()
        
        rankView.listButton.addTarget(self, action: "listButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let user = AppController.instance.user {
            user.fetchWeeklySexEvents({ (events:[AnyObject]?, error:NSError?) -> Void in
                self.configureView()
            })
        }
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
            
            self.rankView.hidden = false
            self.rankView.updateRank(user)
        } else {
            self.slider.hidden = true
            self.goalLabael.text = nil
            self.rankView.hidden = true
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "goalModalSegue" {
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
        } else if segue.identifier == "historySegue" {
            
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func trackEventTapped(sender: AnyObject) {
        
        if let user = AppController.instance.user {
            user.trackSexEvent({ (success:Bool, error:NSError?) -> Void in
            })
            
            // Move the slider
            user.weeklyEventCount++
            configureView()

        }
        
    }
    
    func listButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("historySegue", sender: self)
    }
}
