//
//  SBUser.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/4/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit
import Parse

let WeeklyEventCountUpdatedNotification = "WeeklyEventCountUpdatedNotification"

@objc class SBUser: NSObject, NSCoding {
    
    
    var firstName:String?
    var gender:String?
    var ageRange:String?
    var weeklySexGoal:Int = 0
    var rewardsPoints:Int = 0
    
    
    // MARK: 30 Day Challenge Data, For now this is kind of brute force
    // TODO: THese need to all go on ChallengeController
    var notifyOfNewChallenges:Bool = false {
        didSet {
            if notifyOfNewChallenges {
                let types:UIUserNotificationType = [.Badge, .Sound, .Alert]
                let mySettings = UIUserNotificationSettings(forTypes: types, categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
            }
        }
    }
    
    var challengeStarted:Bool = false
    var challengedCompleted:Bool = false
    
    var _challengeStartDate:NSDate?
    var challengeStartDate:NSDate? {

        get {
            return _challengeStartDate;
        }
        set {
            if newValue != nil {
                let cal:NSCalendar = NSCalendar.currentCalendar()
                _challengeStartDate = cal.startOfDayForDate(newValue!)
            } else {
                _challengeStartDate = nil
            }
            challengeStarted = _challengeStartDate != nil
        }
        
    }
    var currentChallengeDay:Int {
        get {
            if challengeStartDate == nil {
                return -1
            } else {
                return NSDate.daysBetweenDates(challengeStartDate!, toDate: NSDate()) + 1
            }
        }
    }
    var completedChallengeDays:NSMutableSet?
    var seenChallengeCheckpoints:[Int:Bool]! {
        didSet {
            if seenChallengeCheckpoints == nil {
                seenChallengeCheckpoints = [1:false, 2:false, 3:false]
            }
        }
    }
    // TODO: End should go on challenge controller, leaving here for now for archive purposes
    
    // We'll cache this an update it from the server every once in awhile
    var weeklyEventCount:Int = 0 {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(WeeklyEventCountUpdatedNotification, object: nil)
            
            // Reward if they've exceeded their goal (but only the first time)
            if (weeklyEventCount == self.weeklySexGoal + 1) {
                RewardsController.instance.exceededSexGoal()
            }
            
        }
    }
    
    var profileImage:UIImage? {
        didSet {
            if profileImage != oldValue {
                profileImageDirty = true
            }
        }
    }
    
    
    private var profileImageDirty:Bool = false
    var objectId:String? // Parse
    private var parseUser:PFObject?
    
    func trackSexEvent(block:PFBooleanResultBlock?) {
        let event:PFObject = PFObject(className: "SBEvent")
        event["user"] = PFObject(outDataWithClassName: "SBUser", objectId: self.objectId)
        event["eventDate"] = NSDate()
        event.saveInBackgroundWithBlock(block)
        
        // Reward Points
        RewardsController.instance.sexTracked()
    }
    
    func fetchAllMySexEvents(after:NSDate?, block:PFArrayResultBlock?) {
        if let parseUser = self.parseUser {
            
            let query:PFQuery = PFQuery(className: "SBEvent")
            query.whereKey("user", equalTo: parseUser)
            if let afterDate = after {
                query.whereKey("eventDate", greaterThanOrEqualTo: afterDate)
            }
            query.findObjectsInBackgroundWithBlock({ (events:[AnyObject]?, error:NSError?) -> Void in
                block?(events, error)
            })
        } else {
            block?([], nil)
        }
    }
    
    func fetchWeeklySexEvents(block:PFArrayResultBlock?) {
        
        if let parseUser = self.parseUser {
            
            let date:NSDate = NSDate()
            let week:(NSDate, NSDate) = NSDate.getRangeOfWeek(date)
            
            // Perform the query
            let query:PFQuery = PFQuery(className: "SBEvent")
            query.whereKey("user", equalTo: parseUser)
            query.whereKey("eventDate", greaterThanOrEqualTo: week.0)
            query.whereKey("eventDate", lessThanOrEqualTo: week.1)
            query.findObjectsInBackgroundWithBlock({ (events:[AnyObject]?, error:NSError?) -> Void in
                if events != nil && error == nil {
                    self.weeklyEventCount = events!.count
                } else {
                    //self.weeklyEventCount = 0
                }
                block?(events, error)
            })
            
        } else {
            
            // Need the user first
            fetchParseUserWithBlock({ (user:PFObject?, error:NSError?) -> Void in
                if error == nil && user != nil {
                    self.fetchWeeklySexEvents(block)
                }
            })
        }
        
    }
    
    private var isSavingInParse:Bool = false
    func updateInParse() {
        
        if (isSavingInParse) {
            return
        }
        
        isSavingInParse = true
        if let parseUser = self.parseUser {
            fillParseUser(parseUser)
            parseUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                self.isSavingInParse = false
            })
        } else if let _ = self.objectId {
            fetchParseUserWithBlock({ (user:PFObject?, error:NSError?) -> Void in
                
                if error == nil && user != nil {
                    self.fillParseUser(user!)
                    user!.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        self.isSavingInParse = false
                    })

                }
    
            })
        } else {
            
            // Create the user in parse
            let parseUser:PFObject = PFObject(className:"SBUser")
            fillParseUser(parseUser)
            parseUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    NSLog("ObjectId: %@", parseUser.objectId!)
                    self.isSavingInParse = false
                    self.objectId = parseUser.objectId
                    self.parseUser = parseUser
                }
            })
           
        }
        
    }
    
    func fetchParseUserWithBlock(block:PFObjectResultBlock?) {
        
        if let objectId = self.objectId {
            let query:PFQuery = PFQuery(className:"SBUser")
            query.getObjectInBackgroundWithId(objectId, block: { (user:PFObject?, error:NSError?) -> Void in
                if error == nil && user != nil {
                    self.fillModelFields(user!)
                    self.parseUser = user
                    block?(user, nil)
                    
                    // Bootstrap this count
                    self.fetchWeeklySexEvents(nil)
                    
                }
            })
        }
    }
    
    func fillModelFields(parseUser:PFObject) {
        if let firstName = parseUser["first_name"] {
            self.firstName = firstName as! String
        }
        if let gender = parseUser["gender"] {
            self.gender = gender as! String
        }
        if let ageRange = parseUser["age_range"] {
            self.ageRange = ageRange as! String
        }
        if let weeklySexGoal = parseUser["weekly_sex_goal"] {
            self.weeklySexGoal = weeklySexGoal as! Int
        }
        if let rewardsPoints = parseUser["rewards_points"] {
            self.rewardsPoints = rewardsPoints as! Int
        }
    }
    func fillParseUser(parseUser:PFObject){
        
        if let firstName = self.firstName {
            parseUser["first_name"] = firstName
        }
        if let gender = self.gender {
            parseUser["gender"] = gender
        }
        if let ageRange = self.ageRange {
            parseUser["age_range"] = ageRange
        }
        
        parseUser["weekly_sex_goal"] = weeklySexGoal
        parseUser["rewards_points"] = rewardsPoints

        if profileImageDirty {
            let imageData = UIImageJPEGRepresentation(self.profileImage!, 0.8)
            let imageFile = PFFile(name: "profile.jpg", data:imageData!)
            parseUser["profile_image"] = imageFile
            profileImageDirty = false
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objectId, forKey: "objectId")
        aCoder.encodeObject(firstName, forKey: "firstName")
        aCoder.encodeObject(ageRange, forKey: "ageRange")
        aCoder.encodeInteger(weeklySexGoal, forKey: "weeklySexGoal")
        aCoder.encodeInteger(weeklyEventCount, forKey: "weeklyEventCount")
        aCoder.encodeBool(notifyOfNewChallenges, forKey: "notifyOfNewChallenges")
        aCoder.encodeBool(challengeStarted, forKey: "challengeStarted")
        aCoder.encodeBool(challengedCompleted, forKey: "challengedCompleted")
        aCoder.encodeObject(completedChallengeDays, forKey: "completedChallengeDays")
        aCoder.encodeObject(challengeStartDate, forKey: "challengeStartDate")
        aCoder.encodeObject(seenChallengeCheckpoints, forKey: "seenChallengeCheckpoints")
        aCoder.encodeInteger(rewardsPoints, forKey: "rewardsPoints")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.objectId = aDecoder.decodeObjectForKey("objectId") as? String
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        self.ageRange = aDecoder.decodeObjectForKey("ageRange") as? String
        self.weeklySexGoal = aDecoder.decodeIntegerForKey("weeklySexGoal")
        self.weeklyEventCount = aDecoder.decodeIntegerForKey("weeklyEventCount")
        self.notifyOfNewChallenges = aDecoder.decodeBoolForKey("notifyOfNewChallenges")

        self.challengeStarted = aDecoder.decodeBoolForKey("challengeStarted")
        self.challengedCompleted = aDecoder.decodeBoolForKey("challengedCompleted")
        self.challengeStartDate = aDecoder.decodeObjectForKey("challengeStartDate") as? NSDate
        self.seenChallengeCheckpoints = aDecoder.decodeObjectForKey("seenChallengeCheckpoints") as? [Int:Bool]
        if seenChallengeCheckpoints == nil {
            seenChallengeCheckpoints = [1:false, 2:false, 3:false]
        }
        
        if let archivedChallengeDays = aDecoder.decodeObjectForKey("completedChallengeDays") as? NSSet {
            self.completedChallengeDays = archivedChallengeDays.mutableCopy() as! NSMutableSet
        }
        
        self.rewardsPoints = aDecoder.decodeIntegerForKey("rewardsPoints")

        self.fetchParseUserWithBlock(nil);
        
    }
    
    
    // MARK: Ranking
 
}
