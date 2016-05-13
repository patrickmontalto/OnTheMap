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
        
        // Check network connection
        if !Reachability.isConnectedToNetwork() {
            displayAlert("No network connection detected.")
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
        
        // Check network connection
        if !Reachability.isConnectedToNetwork() {
            displayAlert("No network connection detected.")
            return
        }
        OTMDataSource.sharedDataSource().getStudentLocationData()
    }
    
    func studentLocationsDidError() {
        for viewController in self.childViewControllers {
            if let mapViewController = viewController as? MapViewController {
                mapViewController.setUIenabled(true)
            } else if let listViewController = viewController as? ListViewController {
                listViewController.setUIenabled(true)
            }
        }
        // Check network connection
        if Reachability.isConnectedToNetwork(){
            displayAlert("Failed to update student locations.")
        } else {
            displayAlert("No network connection detected.")
        }
    }

    // MARK: Present location prompt
    private func displayLocationPrompt() {
        let studentLocationNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocationNavigationController") as! UINavigationController
        self.presentViewController(studentLocationNavigationController, animated: true, completion: nil)
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
    
}

