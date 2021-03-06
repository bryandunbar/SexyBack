//
//  NavControllerReplaceSegue.swift
//  SexyBack
//
//  Created by Bryan Dunbar on 9/15/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

import UIKit

class NavControllerReplaceSegue: UIStoryboardSegue {
   
    override func perform() {
        let sourceViewController = self.sourceViewController 
        let destinationViewController = self.destinationViewController 
        
        let navigationController = sourceViewController.navigationController
        
        navigationController?.popViewControllerAnimated(false)
        navigationController?.pushViewController(destinationViewController, animated: false)
    }
}
