//
//  MenuViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate {
    func itemSelected(controller:MenuViewController, menuItem:MenuItem)
}

enum MenuItemType:Int {
    case Tracker = 0, Challenge, Settings, Help
}

struct MenuItem {

    var type:MenuItemType
    var title:String!
    var iconFileName:String?
    var segueIdentifier:String?
    var viewControllerIdentifier:String?
    var viewController:UIViewController?
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let menuItems:[MenuItem] = [
        MenuItem(type: MenuItemType.Tracker, title: "Tracker", iconFileName: "tracker", segueIdentifier: "trackerSegue", viewControllerIdentifier:nil, viewController:nil),
        MenuItem(type: MenuItemType.Challenge, title: "30 Day Challenge", iconFileName: "challenge", segueIdentifier: "challengeSegue", viewControllerIdentifier:nil, viewController:nil),
    ]
    
    var delegate:MenuViewControllerDelegate?
    
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
        
        let menuItem:MenuItem = menuItems[indexPath.row]
        
        cell.textLabel!.text = menuItem.title
        if let imageFileName = menuItem.iconFileName {
            cell.imageView?.image = UIImage(named:imageFileName)
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let delegate = self.delegate {
            let menuItem = menuItems[indexPath.row]
            delegate.itemSelected(self, menuItem: menuItem)
        }
    }
}
