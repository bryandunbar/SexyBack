//
//  RewardsViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 10/17/15.
//  Copyright © 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class RewardsViewController: BaseSexyBackViewController {
    @IBOutlet var myRewardsPoints: RoundedLabel!

    @IBOutlet var nextRewardLevel: UILabel!
    
    private var nextRewardFormatString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMenuItemType = MenuItemType.Rewards
        self.nextRewardFormatString = self.nextRewardLevel!.text // Grab from IB before it gets set
        
        configureView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        var currentPoints:Int = 0
        if let user = AppController.instance.user {
            currentPoints = user.rewardsPoints
        }

        self.myRewardsPoints!.text = NSNumberFormatter.localizedStringFromNumber(currentPoints, numberStyle: .DecimalStyle)
        
        self.nextRewardLevel!.text = String(format: nextRewardFormatString, NSNumberFormatter.localizedStringFromNumber(RewardsController.instance.nextRewardLevel(), numberStyle: .DecimalStyle))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
