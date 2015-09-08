//
//  MenuViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let menuItems:[String] = ["Tracker", "30 Day Challenge"]
    let menuIcons:[String] = ["tracker", "challenge"]
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    @IBAction func menuButtonTapped(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = menuItems[indexPath.row]
        cell.imageView?.image = UIImage(named: menuIcons[indexPath.row])
        return cell
    }
}
