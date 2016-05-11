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
                if let errorString = errorString {
                    self.displayAlert(errorString)
                }
            }
        }
        
    }
    @IBAction func addNew(sender: AnyObject) {
        /* GUARD: Is there a student stored in the shared model? */
        guard let student = OTMDataSource.sharedDataSource().student else {
            displayAlert("Error: Current student not found")
            return
        }
        performUIUpdatesOnMain() {
            if student.hasStoredLocation() {
                self.displayOverwriteAlert(student)
            } else {
                self.displayLocationPrompt()
            }
        }
    }
    
    @IBAction func refreshLocations(sender: AnyObject) {
        // Populate annotations array and update MapView annotations
        OTMDataSource.sharedDataSource().getStudentLocationData()
    }
    
    func studentLocationsDidError() {
        displayAlert("Failed to update student locations.")
    }
    
    // MARK: Present location prompt
    private func displayLocationPrompt() {
        let locationPromptViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LocationPrompt") as! LocationPromptViewController
        self.presentViewController(locationPromptViewController, animated: true, completion: nil)
    }
    // MARK: - Alerts
    
    // MARK: Display Overwrite Confirmation
    private func displayOverwriteAlert(student: Student) {
        let refreshAlert = UIAlertController(title: "", message: "\(student.fullName) has already posted a Student Location. Would you like to overwrite their location?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Overwrite", style: .Default, handler: { (action: UIAlertAction!) in
            self.displayLocationPrompt()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: Display Alert
    
    private func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: completionHandler))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

