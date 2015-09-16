//
//  DareIntroViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/14/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class DareIntroViewController: BaseSexyBackViewController {

    var challenge:Challenge!
    
    @IBOutlet var challengeTitle: UILabel!
    @IBOutlet var challengeBody: UILabel!
    
    @IBOutlet var notificationCheckbox: CheckBox!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMenuItemType = MenuItemType.Challenge
        
        // TODO: Just harcoded for now
        challenge = ChallengeController.instance.getChallenge("1")

        if let user = AppController.instance.user {
            if user.challengeStarted {
                self.performSegueWithIdentifier("challengeDetailSegueNotAnimated", sender: self)
            } else {
                challengeTitle.text = challenge.name.uppercaseString
                challengeBody.text = challenge.body
            }
        }
    }

   
    @IBAction func startChallengeTapped(sender: AnyObject) {
        
        // Initiate the challenge
        ChallengeController.instance.startChallenge(challenge, wantsNotifications:notificationCheckbox.isChecked)
        
        // Go to the first challenge item
        self.performSegueWithIdentifier("challengeDetailSegueAnimated", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let asRange = segue.identifier?.rangeOfString("challengeDetailSegue")
        if let asRange = asRange where asRange.startIndex == segue.identifier?.startIndex {
            let detailViewController = segue.destinationViewController as! ChallengeDetailViewController
            detailViewController.challenge = self.challenge
        }
    }
}
