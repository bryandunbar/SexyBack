//
//  ChallengeDetailPageViewController.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 10/17/15.
//  Copyright © 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class ChallengeDetailPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var challenge:Challenge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let challengeItem = ChallengeController.instance.getCurrentItem(challenge)
        
        // Bootstrap
        var vc:UIViewController?
        if let user = AppController.instance.user {
            if user.challengedCompleted {
                
                vc = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeCompletedViewController") as! ChallengeCompleteViewController
                
            }
        }
        
        if vc == nil {
            vc = self.viewControllerAtIndex(challengeItem!.day - 1)
        }
        
        self.delegate = self
        self.dataSource = self
        self.view.backgroundColor = UIColor(red: 224/255.0, green: 225/255.0, blue: 224/255.0, alpha: 1.0)
        
        self.setViewControllers([vc!], direction: .Forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index:Int) -> ChallengeDetailViewController {
        
        let vc:ChallengeDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeDetailViewController") as! ChallengeDetailViewController
        vc.challenge = self.challenge
        vc.challengeItem = self.challenge.getItemByDay(index + 1) // Days are 1 index
        return vc
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        
        // Nothing comes after the complete view controller
        if let _ = viewController as? ChallengeCompleteViewController {
            return nil
        }
        
        let challengeDetailViewController = viewController as! ChallengeDetailViewController
        var index:Int = challengeDetailViewController.challengeItem.day - 1 // Days are 1 indexed
        index += 1
        if index == self.challenge.items.count {
            
            // We are at the end of the regular challenges, check to see if they are done and add the
            // completed view controller
            if let user = AppController.instance.user {
                if user.challengedCompleted {
                    let vc:ChallengeCompleteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChallengeCompletedViewController") as! ChallengeCompleteViewController
                    return vc
                }
            }
            
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index:Int = 0
        if let _ = viewController as? ChallengeCompleteViewController {
            index = challenge.lastItem.day
        } else {
            let challengeDetailViewController = viewController as! ChallengeDetailViewController
            index = challengeDetailViewController.challengeItem.day - 1 // Days are 1 indexed
        }
        
        // Nothing comes before teh first one
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
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
