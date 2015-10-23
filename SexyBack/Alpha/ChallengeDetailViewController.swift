//
//  ChallengeDetailViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: BaseSexyBackViewController {

    var challenge:Challenge!
    var challengeItem:ChallengeItem!
    
    let modalTransitioningDelegate = BouncyOverlayTransitioningDelegate()

    
    @IBOutlet var challengeDay: UILabel!
    @IBOutlet var challengeTitle: UILabel!
    @IBOutlet var challengeBody: UILabel!
    @IBOutlet var challengeImage: BorderedImageView!
    @IBOutlet var challegeCompleteCheckbox: CheckBox!
    @IBOutlet var challengeCompleteButton: UIBorderedButton!
    @IBOutlet var shareButton: UIBorderedButton!
    
    var checkpoint:[String:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMenuItemType = .Challenge
        configureView()
        
        if let user = AppController.instance.user {
            if user.challengedCompleted {
                performSegueWithIdentifier("challengeCompleted", sender: self)
            } else {
                self.checkpoint = ChallengeController.instance.currentCheckpoint
                if self.checkpoint != nil {
                    performSegueWithIdentifier("checkpointSegue", sender: self)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        shareButton.addTarget(self, action: "shareTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if let challengeItem = self.challengeItem {
            challengeDay.text = String(format: "DAY %d", challengeItem.day)
            challengeTitle.text = challengeItem.title.uppercaseString
            challengeBody.text = challengeItem.body
            challengeImage.image = challengeItem.thumbnailImage
            
            // Set the completion
            challengeCompleteButton.enabled = !ChallengeController.instance.hasUserCompletedItem(challenge, item: challengeItem)
            challegeCompleteCheckbox.isChecked = !challengeCompleteButton.enabled
            
            challengeCompleteButton.setTitle(challegeCompleteCheckbox.isChecked ? "Done. Good Job!" : "Mark Complete", forState: UIControlState.Normal)
        } else {
            self.view.hidden = true
        }

        
    }
    
    func shareTapped(sender: AnyObject) {
        let textToShare = "Check out this app!"
        
        if let myWebsite = NSURL(string: "http://www.gysexyback.com/")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func challengeCompletedTapped(sender: AnyObject) {
        ChallengeController.instance.completeChallengeItem(challenge, item: challengeItem!)
        configureView()
    }


    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "checkpointSegue" {
            let vc:ChallengeCheckpointViewController = segue.destinationViewController as! ChallengeCheckpointViewController
            vc.transitioningDelegate = modalTransitioningDelegate
            vc.modalPresentationStyle = .Custom
            vc.checkpoint = checkpoint

        } 
    }

}
