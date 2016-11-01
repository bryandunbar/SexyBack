//
//  RewardsController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 10/26/15.
//  Copyright © 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class RewardsController: NSObject {

    var rewardLevels:[Int] = [1000,5000,10000,15000,25000]
    
    class var instance: RewardsController  {
        struct Singleton {
            static let instance = RewardsController()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
    
    func currentRewardPoints() -> Int {
        if let user = AppController.instance.user {
            return user.rewardsPoints
        }
        
        return 0
    }
    
    func nextRewardLevel() -> Int {
        
        if let user = AppController.instance.user {
            for i in 0 ..< rewardLevels.count {
                if user.rewardsPoints < rewardLevels[i] {
                    return rewardLevels[i]
                }
            }
        }
        
        return rewardLevels[0]
    }
    
    func challengeCompleted() {
        awardRewardPoints(1000)
    }
    
    func sexTracked() {
        awardRewardPoints(150)
    }
    
    func exceededSexGoal() {
        awardRewardPoints(2000)
    }
    
    
    private func awardRewardPoints(numberOfPoints:Int) {
        if let user = AppController.instance.user {
            user.rewardsPoints += numberOfPoints
            AppController.instance.save()
        }
    }
}
