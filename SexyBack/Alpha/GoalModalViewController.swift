//
//  GoalModalViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/4/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class GoalModalViewController: UIViewController {

    @IBOutlet var goalAmount: UITextField!
    var dismissHandler: ((value: Int) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionButtonTapped(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.dismissHandler?(value: self.goalAmount.text.toInt()!)
        })
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
