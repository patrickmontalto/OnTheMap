//
//  OTMTabBarController.swift
//  OnTheMap
//
//  Created by Patrick on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class OTMTabBarController: UITabBarController {
    
    @IBAction func logout(sender: AnyObject) {
        
        UdacityClient.sharedInstance().logout { (success, errorString) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                print(errorString)
            }
        }
        
    }
    
}
