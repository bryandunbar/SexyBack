//
//  AppController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import Foundation
import Parse


struct Theme {
    static var PinkColor = UIColor(red: 169/255, green: 36/255, blue: 57/255, alpha: 1.0)
}

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
