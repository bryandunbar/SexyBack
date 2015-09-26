//
//  AlertViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/26/15.
//  Copyright © 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var button: UIButton!
    @IBAction func buttonTapped(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
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
