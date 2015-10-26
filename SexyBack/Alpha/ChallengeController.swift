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
struct Challenge: CustomStringConvertible {
    let id:String!
    let name:String!
    let body:String!
    let items:[ChallengeItem]!
    
    static func buildKey(id:String, day:Int) -> String {
        return id + ChallengeKeyDelimiter + String(day)
    }

    static func dayFromKey(key:String) -> Int {
        let parts = key.componentsSeparatedByString(ChallengeKeyDelimiter)
        return Int(parts[1])!
    }
    
    func getItemByDay(day:Int) -> ChallengeItem? {
        for item in items {
            if item.day == day {
                return item
            }
        }
        return nil
    }
    
    var lastItem:ChallengeItem {
        get {
            return items!.last!
        }
    }
    
    var description : String {
        return "[" + id + "], name: " + name + ", items: " + String(items.count)
    }
    
    func scheduleNotifications() {
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        var date:NSDate = NSDate()
        date = calendar.startOfDayForDate(date)
        date = date.dateBySettingCalendarComponent(NSCalendarUnit.Hour, value: 8)
        for _:ChallengeItem in items {
            print("Scheduling Notification for: \(date)")
            let localNotif:UILocalNotification = UILocalNotification()
            localNotif.fireDate = date
            localNotif.alertBody = "A New Challenge is Available!"
            localNotif.timeZone = NSTimeZone.defaultTimeZone()
            UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
            
            // Add a day to the date
            date = date.dateByAddingComponentToDate(NSCalendarUnit.Day, value: 1)
        }
        
    }
}

struct ChallengeItem: CustomStringConvertible {
    
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
    
    func scheduleNotificationsForCurrentChallenge() {
        if let challenge = getChallenge("1") {
            challenge.scheduleNotifications()
        }
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
            
            var currentChallengeDay:Int = user.currentChallengeDay
            if currentChallengeDay > challenge.lastItem.day {
                user.challengedCompleted = true
                return nil
            }
            
            return challenge.getItemByDay(currentChallengeDay)
        }
        
        return challenge.getItemByDay(1)
    }
    
//    func setCurrentItem(challenge:Challenge, day:Int) {
//        if let user = AppController.instance.user {
//            user.currentChallengeDay = day
//        }
//    }
    
    func startChallenge(challenge:Challenge, wantsNotifications:Bool) {
        
        if let user = AppController.instance.user {
   
            // Will prompt for push
            if wantsNotifications {
                user.notifyOfNewChallenges = wantsNotifications
                
                // TODO: Setup the series of local notifications
                challenge.scheduleNotifications()
            } else {
                user.notifyOfNewChallenges = false
            }

            // Set that the user is on day 1
            user.challengeStartDate = NSDate()
            user.completedChallengeDays = NSMutableSet()
            
            AppController.instance.save()
            
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
            
            // Reward Points
            RewardsController.instance.challengeCompleted()
            
            AppController.instance.save()
        }
    }
    
    
    var currentCheckpoint:[String:AnyObject]? {
        
        get {
            if let user = AppController.instance.user {
                var currentChallengeDay:Int = user.currentChallengeDay
                var value:[String:AnyObject]? = nil
                let completedChallengeDays:[String] = user.completedChallengeDays!.allObjects as! [String]
                
                if currentChallengeDay >= 8 && currentChallengeDay < 15 {
                    
                    let seen = user.seenChallengeCheckpoints[1]!
                    if !seen {
                        
                        let arr = completedChallengeDays.filter({
                            let dayFromKey = Challenge.dayFromKey($0)
                            return dayFromKey >= 1 && dayFromKey < 8
                        })
                        value = ["msg":String(format:"You've completed Week 1 of the 30-Day Challenge!\n\nYou completed %d challenges.", arr.count)]
                        user.seenChallengeCheckpoints[1] = true
                    }

                } else if currentChallengeDay >= 15 && currentChallengeDay < 22 {
                    let seen = user.seenChallengeCheckpoints[2]!
                    if !seen {
                        value = ["msg":"You've completed Week 2 of the 30-Day Challenge!"]
                        user.seenChallengeCheckpoints[2] = true
                    }
                } else if currentChallengeDay >= 22 {
                    let seen = user.seenChallengeCheckpoints[3]!
                    if !seen {
                        value = ["msg":"You've completed Week 3 of the 30-Day Challenge!"]
                        user.seenChallengeCheckpoints[3] = true
                    }
                }

                return value

            }
            
            return nil
        }
    }
    

}
