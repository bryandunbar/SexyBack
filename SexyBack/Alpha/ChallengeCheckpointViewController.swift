//
//  ChallengeCheckpointViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/22/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class ChallengeCheckpointViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    var checkpoint:[String:AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()

        detailLabel.text = checkpoint["msg"] as! String
        button.setTitle("Continue the Challenge", forState: UIControlState.Normal)
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

    @IBAction func buttonTapped(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
