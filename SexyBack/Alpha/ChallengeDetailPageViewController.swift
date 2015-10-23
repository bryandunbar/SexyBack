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
        self.delegate = self
        self.dataSource = self
        self.view.backgroundColor = UIColor(red: 224/255.0, green: 225/255.0, blue: 224/255.0, alpha: 1.0)
        let challengeItem = ChallengeController.instance.getCurrentItem(challenge)
        let vc:ChallengeDetailViewController = self.viewControllerAtIndex(challengeItem!.day - 1)
        self.setViewControllers([vc], direction: .Forward, animated: false, completion: nil)
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
        
        let challengeDetailViewController = viewController as! ChallengeDetailViewController
        var index:Int = challengeDetailViewController.challengeItem.day - 1 // Days are 1 indexed
        index++
        if index == self.challenge.items.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let challengeDetailViewController = viewController as! ChallengeDetailViewController
        var index:Int = challengeDetailViewController.challengeItem.day - 1 // Days are 1 indexed
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
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
