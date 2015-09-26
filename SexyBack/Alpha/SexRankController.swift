//
//  SexRankController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/9/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

struct SexRank: CustomStringConvertible {
    
    let rankText:String!
    let rankDetail:String!
    let rankImage:UIImage!
    let rankRange:(Int, Int)!
    
    init(rankText:String, rankDetail:String, rankImage:UIImage, rankLowPercentage:Int, rankHighPercentage:Int) {
        self.rankText = rankText
        self.rankDetail = rankDetail
        self.rankImage = rankImage
        self.rankRange = (rankLowPercentage, rankHighPercentage)
    }
    
    var description: String {
        return self.rankText + ": " + self.rankDetail
    }

}

class SexRankController: NSObject {

    private var ranks:[SexRank] = []
    
    /// SexRankController singleton instance
    class var sharedInstance: SexRankController  {
        struct Singleton {
            static let instance = SexRankController()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        
        if let path = NSBundle.mainBundle().pathForResource("Ranks", ofType: "plist") {
            if let arr = NSArray(contentsOfFile: path) {
                for obj:AnyObject in arr {
                    if let rankDict = obj as? NSDictionary {
                        let rank:SexRank = SexRank(rankText: rankDict["text"] as! String, rankDetail: rankDict["detail"] as! String, rankImage: UIImage(named: rankDict["imageName"] as! String)!, rankLowPercentage: rankDict["lowPercentage"] as! Int, rankHighPercentage: rankDict["highPercentage"] as! Int)
                        ranks.append(rank)
                    }
                }
            }
        }
        
    }
    
    func getRank(user:SBUser) -> SexRank? {
        let goal:Float = Float(user.weeklySexGoal)
        let count:Float = Float(user.weeklyEventCount)
        return getRank(goal, eventCount: count)
    }
    
    func getRank(goal:Float, eventCount:Float) -> SexRank? {

        let percentage:Float = eventCount / goal * 100.0
        
        // Find the apppriate rank
        for rank:SexRank in self.ranks {
            if percentage >= Float(rank.rankRange.0) && percentage <= Float(rank.rankRange.1) {
                return rank
            }
        }
        
        return nil
        
    }
    
}
