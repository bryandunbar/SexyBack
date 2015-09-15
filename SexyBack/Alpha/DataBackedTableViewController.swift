//
//  DataBackedTableViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/10/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class DataBackedTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    private var isFetching:Bool = false
    var refreshControl:UIRefreshControl?
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        var tempActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        tempActivityIndicator.hidesWhenStopped = true
        return tempActivityIndicator
    }()
    
    lazy private var noDataLabel:UILabel = {
        [unowned self] in
        
        var tempLabel = UILabel(frame: CGRectZero)
        tempLabel.center = self.tableView.center;
        tempLabel.font = UIFont.boldSystemFontOfSize(15)
        tempLabel.textColor = UIColor.darkGrayColor();
        tempLabel.textAlignment = NSTextAlignment.Center
        tempLabel.text = self.noDataText!;
        tempLabel.sizeToFit()
        return tempLabel
    }()

    var noData:Bool = true {
        didSet {
            if noData && self.noDataText != nil {
                self.noDataLabel.text = self.noDataText!
                self.tableView.backgroundView = self.noDataLabel
            } else {
                self.tableView.backgroundView = nil;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
            }
        }
    }
    
    var noDataText:String? = "No Data" {
        didSet {
            self.noDataLabel.text = noDataText
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doFetch() {
        
    }
    
    func fetchData() {
        fetchData(false)
    }
    
    func fetchData(showActivityIndicator:Bool) {
        if isFetching {
            return
        }
        
        if showActivityIndicator {
            self.tableView.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.tableView.backgroundView = nil
            
            self.tableView.separatorStyle = self.noData ? UITableViewCellSeparatorStyle.None : UITableViewCellSeparatorStyle.SingleLine
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        
        self.doFetch()
    }
    
    func fetchFinished() {
        self.activityIndicator.stopAnimating()
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        isFetching = false
    }
    
    override func viewWillLayoutSubviews() {
        self.activityIndicator.center = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y - 50)
    }
    
    
    // MARK: UITableViewDelegate/DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    
}
