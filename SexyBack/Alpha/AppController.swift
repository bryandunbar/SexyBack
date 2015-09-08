//
//  AppController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import Foundation
import Parse

@objc class AppController: NSObject, NSCoding {
   
    
    /// Convenience to the NSUserDefaults
    private var userDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    /// AppController singleton instance
    class var instance: AppController  {
        struct Singleton {
            static var instance:AppController?
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Singleton.onceToken) {
            if let archive = NSKeyedUnarchiver.unarchiveObjectWithFile(AppController.archiveFilePath) as? AppController {
                Singleton.instance = archive
            }
            
            if Singleton.instance == nil {
                Singleton.instance = AppController()
            }
        }
        return Singleton.instance!
    }
    
    var isOnboarded:Bool {
        set {
            userDefaults.setBool(newValue, forKey: "isOnboarded")
            userDefaults.synchronize()
        }
        
        get {
            return userDefaults.boolForKey("isOnboarded")
        }
    }
    
    var user:SBUser? {
        didSet {
            self.save()
        }
    }
    
    func save() -> Bool {
        user?.updateInParse()
        return NSKeyedArchiver.archiveRootObject(self, toFile: AppController.archiveFilePath)
    }
    
    class var archiveFilePath:String {
        get {
            let docDir:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
            return docDir.stringByAppendingPathComponent("SexyBackState.plist")
        }
    }
    
    
    func getRangeOfWeek(date:NSDate) -> (NSDate, NSDate) {
        
        let cal = NSCalendar.currentCalendar()

        var beginningOfWeek: NSDate?
        var weekDuration = NSTimeInterval()
        cal.rangeOfUnit(.CalendarUnitWeekOfYear, startDate: &beginningOfWeek, interval: &weekDuration, forDate: date)
        let endOfWeek = beginningOfWeek?.dateByAddingTimeInterval(weekDuration)
        return (beginningOfWeek!, endOfWeek!)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.user = aDecoder.decodeObjectForKey("user") as? SBUser
    }
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(user, forKey: "user")
    }
    
    override init() {
        super.init()
    }
    

}
