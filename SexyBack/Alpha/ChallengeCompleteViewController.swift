//
//  ChallengeCompleteViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class ChallengeCompleteViewController: BaseSexyBackViewController {
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMenuItemType = .Challenge
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = AppController.instance.user {
            
            let completedChallengeDays:[String] = user.completedChallengeDays!.allObjects as! [String]
            let arr = completedChallengeDays.filter({
                let dayFromKey = Challenge.dayFromKey($0)
                return dayFromKey >= 1
            })
            
            let str:String = String(format: "You've completed the 30-Day Challenge!\n\nYou completed %d challenges.", arr.count)
            
            self.label.text = str
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
