//
//  OTMTabBarController.swift
//  OnTheMap
//
//  Created by Patrick on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class OTMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidError", name: "studentLocationsError", object: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        UdacityClient.sharedInstance().logout { (success, errorString) -> Void in
            if success {
                performUIUpdatesOnMain() {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                // TODO: Implement error handling for logout
                print(errorString)
            }
        }
        
    }
    @IBAction func addNew(sender: AnyObject) {
        // TODO: Implement method to input new Location (LocationPromptViewController)
    }
    
    @IBAction func refreshLocations(sender: AnyObject) {
        // Populate annotations array and update MapView annotations
        OTMDataSource.sharedDataSource().getStudentLocationData()
    }
    
    private func studentLocationsDidError() {
        // TODO: Implement UI Alert Action: "Failed to update student locations."
    }
}

