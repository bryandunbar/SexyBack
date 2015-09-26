//
//  PushNoAnimationSegue.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/3/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {
   
    override func perform() {
        self.sourceViewController.navigationController!.pushViewController(self.destinationViewController as! UIViewController, animated: false)
    }
}
