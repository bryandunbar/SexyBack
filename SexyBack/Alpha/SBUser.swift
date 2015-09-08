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
    
    // We'll cache this an update it from the server every once in awhile
    var weeklyEventCount:Int = 0 {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(WeeklyEventCountUpdatedNotification, object: nil)
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
    private var objectId:String? // Parse
    private var parseUser:PFObject?
    
    func trackSexEvent(block:PFBooleanResultBlock?) {
        var event:PFObject = PFObject(className: "SBEvent")
        event["user"] = PFObject(withoutDataWithClassName: "SBUser", objectId: self.objectId)
        event.saveInBackgroundWithBlock(block)
    }
    
    func fetchWeeklySexEvents(block:PFArrayResultBlock?) {
        
        if let parseUser = self.parseUser {
            
            let date:NSDate = NSDate()
            let week:(NSDate, NSDate) = AppController.instance.getRangeOfWeek(date)
            
            // Perform the query
            var query:PFQuery = PFQuery(className: "SBEvent")
            query.whereKey("user", equalTo: parseUser)
            query.whereKey("createdAt", greaterThanOrEqualTo: week.0)
            query.whereKey("createdAt", lessThanOrEqualTo: week.1)
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
    
    
    func updateInParse() {
        
        if let parseUser = self.parseUser {
            fillParseUser(parseUser)
            parseUser.saveInBackground()
        } else if let objectId = self.objectId {
            fetchParseUserWithBlock({ (user:PFObject?, error:NSError?) -> Void in
                
                if error == nil && user != nil {
                    self.fillParseUser(user!)
                    user!.saveInBackground()
                }
    
            })
        } else {
            
            // Create the user in parse
            var parseUser:PFObject = PFObject(className:"SBUser")
            fillParseUser(parseUser)
            parseUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    NSLog("ObjectId: %@", parseUser.objectId!)
                    self.objectId = parseUser.objectId
                    self.parseUser = parseUser
                }
            })
           
        }
        
    }
    
    func fetchParseUserWithBlock(block:PFObjectResultBlock?) {
        
        if let objectId = self.objectId {
            var query:PFQuery = PFQuery(className:"SBUser")
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
        
        if profileImageDirty {
            let imageData = UIImageJPEGRepresentation(self.profileImage!, 0.8)
            let imageFile = PFFile(name: "profile.jpg", data:imageData)
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
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.objectId = aDecoder.decodeObjectForKey("objectId") as? String
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        self.ageRange = aDecoder.decodeObjectForKey("ageRange") as? String
        self.weeklySexGoal = aDecoder.decodeIntegerForKey("weeklySexGoal")
        self.weeklyEventCount = aDecoder.decodeIntegerForKey("weeklyEventCount")
        self.fetchParseUserWithBlock(nil);
        
    }
 
}