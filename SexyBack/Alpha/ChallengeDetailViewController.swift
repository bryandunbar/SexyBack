//
//  ChallengeDetailViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: BaseSexyBackViewController {

    var challenge:Challenge! {
        didSet {
            self.challengeItem = ChallengeController.instance.getCurrentItem(challenge)
        }
    }
    var challengeItem:ChallengeItem!
    
    @IBOutlet var challengeDay: UILabel!
    @IBOutlet var challengeTitle: UILabel!
    @IBOutlet var challengeBody: UILabel!
    @IBOutlet var challengeImage: BorderedImageView!
    @IBOutlet var challegeCompleteCheckbox: CheckBox!
    @IBOutlet var challengeCompleteButton: UIBorderedButton!
    @IBOutlet var shareButton: UIBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMenuItemType = .Challenge
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        if let challengeItem = self.challengeItem {
            challengeDay.text = String(format: "DAY: %d", challengeItem.day)
            challengeTitle.text = challengeItem.title.uppercaseString
            challengeBody.text = challengeItem.body
            challengeImage.image = challengeItem.thumbnailImage
            
            if let user = AppController.instance.user {
                challengeCompleteButton.enabled = !ChallengeController.instance.hasUserCompletedItem(challenge, item: challengeItem)
                challegeCompleteCheckbox.isChecked = !challengeCompleteButton.enabled
                
                challengeCompleteButton.setTitle(challegeCompleteCheckbox.isChecked ? "Done. Good Job!" : "Mark Complete", forState: UIControlState.Normal)
            }
        }
        
    }
    
    @IBAction func challengeCompletedTapped(sender: AnyObject) {
        ChallengeController.instance.completeChallengeItem(challenge, item: challengeItem)
        configureView()
    }

    @IBOutlet var shareTapped: UIBorderedButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
