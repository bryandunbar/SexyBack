//
//  SexTrackerHistoryViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/10/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit
import Parse

class SexTrackerHistoryViewController: DataBackedTableViewController {

    private var data:[Int:[PFObject]]? {
        didSet {
            noData = data?.count == 0
            tableView.reloadData()
        }
    }
    
    private var sortedKeys:[Int]? {
        get {
            if let data = data {
                let keys:[Int] = Array(data.keys)
                return keys.sort(>)
            }
            return nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = Theme.PinkColor
        self.title = "Weekly History"
        noDataText = "No History Available"
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        fetchData(true)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func doFetch() {
        
        if let user = AppController.instance.user {
            
            if let afterDate = NSDate().dateBySubtractingWeeksFromDate(5) {
                user.fetchAllMySexEvents(afterDate, block: { (events:[AnyObject]?, error:NSError?) -> Void in
                    if events != nil && error == nil {
                        self.organizeEventsByWeek(events as! [PFObject])
                    } else {
                        self.data = nil
                    }
                    self.fetchFinished()
                })
            }
        }
        
    }
    
    func organizeEventsByWeek(events:[PFObject]) {
        
        var tempDict = [Int:[PFObject]]()
        for event:PFObject in events {
            let weekOfYear = (event["eventDate"] as! NSDate).getCalendarComponent(NSCalendarUnit.WeekOfYear)
            if let arr = tempDict[weekOfYear] {
                var tempArray = [PFObject]()
                tempArray += arr
                tempArray.append(event)
                tempDict[weekOfYear] = tempArray
            } else {
                // Don't have this one yet
                tempDict[weekOfYear] = [event]
            }
        }
        
        self.data = tempDict
        
    }
    
    
    // MARK: - UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data != nil ? data!.count : 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let keys = sortedKeys {
            let currentYear = NSDate().getCalendarComponent(NSCalendarUnit.Year)
            let weekOfYear = keys[section]
            let date = NSDate.getFirstDateOfWeekFromWeekNumber(weekOfYear, inYear: currentYear)
            let dataStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .NoStyle)
            return String(format: "Week of %@", dataStr)
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func eventArrayRowAtIndexPath(indexPath:NSIndexPath) -> [PFObject]? {
        if let data = data {
            if let keys = sortedKeys {
                if let events = data[keys[indexPath.section]] {
                    return events
                }
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SexHistoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! SexHistoryTableViewCell
        configureCell(cell, indexPath:indexPath)
        return cell
    }
    
    func configureCell(cell:SexHistoryTableViewCell, indexPath:NSIndexPath) {
        
        let events = eventArrayRowAtIndexPath(indexPath)!
        if let user = AppController.instance.user {
            
            // Compute the rank
            let goal:Float = Float(user.weeklySexGoal)
            let eventCount:Float = Float(events.count)
            let percentage:Float = eventCount / goal * 100.0
            let rank:SexRank = SexRankController.sharedInstance.getRank(goal, eventCount: eventCount)!
            
            // Configure the cell
            cell.rankImageView.image = rank.rankImage
            cell.rankTextLabel.text = rank.rankText
            cell.goalTextLabel.text = String(format: "%d%% of goal", Int(percentage))
            
        }
        
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
