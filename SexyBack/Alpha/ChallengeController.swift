//
//  ChallengeController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit
import Parse

let ChallengeKeyDelimiter = "::"
struct Challenge: Printable {
    let id:String!
    let name:String!
    let body:String!
    let items:[ChallengeItem]!
    
    static func buildKey(id:String, day:Int) -> String {
        return id + ChallengeKeyDelimiter + String(day)
    }
    
    
    func getItemByDay(day:Int) -> ChallengeItem? {
        for item in items {
            if item.day == day {
                return item
            }
        }
        return nil
    }
    
    var description : String {
        return "[" + id + "], name: " + name + ", items: " + String(items.count)
    }
}

struct ChallengeItem: Printable {
    
    let day:Int!
    let title:String!
    let body:String!
    let thumbnailImage:UIImage!
    
    var description: String {
        return String(self.day) + ": " + self.title!
    }
    
}

class ChallengeController: NSObject {
   
    var challenges:[Challenge] = []

    class var instance: ChallengeController  {
        struct Singleton {
            static let instance = ChallengeController()
        }
        return Singleton.instance
    }
    
    func getChallenge(id:String) -> Challenge? {
        for challenge:Challenge in challenges {
            if challenge.id == id {
                return challenge
            }
        }
        
        return nil
    }
    
    override init() {
        super.init()
        
        //TODO: At least read this plist from server
        if let path = NSBundle.mainBundle().pathForResource("Challenges", ofType: "plist") {
            if let arr = NSArray(contentsOfFile: path) {
                for obj:AnyObject in arr {
                    if let challengeDict = obj as? NSDictionary {
                        
                        let itemArray = challengeDict["items"] as! [NSDictionary]
                        var items:[ChallengeItem] = []
                        for item:NSDictionary in itemArray {
                            items.append(
                                ChallengeItem(day: item["day"] as! Int,
                                    title: item["title"] as! String,
                                    body: item["body"] as! String,
                                    thumbnailImage: UIImage(named: item["thumbnailFileName"] as! String))
                            )
                        }
                        
                        let challenge:Challenge = Challenge(
                            id: challengeDict["id"] as! String,
                            name: challengeDict["name"] as! String,
                            body: challengeDict["body"] as! String,
                            items: items
                        )
                        challenges.append(challenge)
                    }
                }
            }
        }
    }
    
    
    func getCurrentItem(challenge:Challenge) -> ChallengeItem? {
        if let user = AppController.instance.user {
            return challenge.getItemByDay(user.currentChallengeDay)
        }
        
        return challenge.getItemByDay(1)
    }
    
    func setCurrentItem(challenge:Challenge, day:Int) {
        if let user = AppController.instance.user {
            user.currentChallengeDay = day
        }
    }
    
    func startChallenge(challenge:Challenge, wantsNotifications:Bool) {
        
        if let user = AppController.instance.user {
   
            // Will prompt for push
            if wantsNotifications {
                user.notifyOfNewChallenges = wantsNotifications
                
                // TODO: Setup the series of local notifications
            } else {
                user.notifyOfNewChallenges = false
            }

            // Set that the user is on day 1
            user.currentChallengeDay = 1
            user.challengeStarted = true
            user.completedChallengeDays = NSMutableSet()
            
            AppController.instance.save()
            
        }
    }
    
    func advanceChallengeDay(challenge:Challenge) {
        if let currentItem = getCurrentItem(challenge) {
            
            let count = challenge.items.count
            if currentItem.day < count {
                setCurrentItem(challenge, day: currentItem.day + 1)
                
                // TODO: Notification?
                
                AppController.instance.save()
            }
        }
    }
    
    func hasUserCompletedItem(challenge:Challenge, item:ChallengeItem) -> Bool {
        var challengeKey:String = Challenge.buildKey(challenge.id, day: item.day)
        if let user = AppController.instance.user {
            if let completedChallengeDays = user.completedChallengeDays {
                return completedChallengeDays.containsObject(challengeKey)
            }
        }
        return false
    }
    
    func completeChallengeItem(challenge:Challenge, item:ChallengeItem) {
        var challengeKey:String = Challenge.buildKey(challenge.id, day: item.day)
        
        if let user = AppController.instance.user {
            user.completedChallengeDays?.addObject(challengeKey)
        
            var event:PFObject = PFObject(className: "SBChallengeTrackRecord")
            event["user"] = PFObject(withoutDataWithClassName: "SBUser", objectId: user.objectId)
            event["eventDate"] = NSDate()
            event["challengeId"] = challenge.id
            event["challengeDay"] = item.day
            event.saveInBackground()
            
            //TODO: Analytics
            
            
            AppController.instance.save()
        }
    }

}
