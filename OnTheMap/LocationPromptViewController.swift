//
//  LocationPromptViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import MapKit

class LocationPromptViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var locationTextView: UITextField!
    @IBOutlet var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove border of nav bar
        removeNavigationbarBorder()
        // Set delegate for text field
        locationTextView.delegate = self
    }
    
    @IBAction func cancelPrompt(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // TODO: Implement #findOnMap()
    @IBAction func findOnMap(sender: AnyObject) {
        // 1. check to see if locationTextView has value
        /* GUARD: Does locationTextView have a value ? */
        guard let locationString = locationTextView.text where locationTextView.text != nil else {
            displayAlert("You must enter a location")
            return
        }
        
        /* Is the location a valid location? */
        let geocoder = CLGeocoder()
        do {
            geocoder.geocodeAddressString(locationString, completionHandler: { (results, error) in
                // Check for error
                if let _ = error {
                    self.displayAlert("Could not geocode provided location.")
                    return
                }
                
                // Check for results
                guard let results = results else {
                    self.displayAlert("Location not found.")
                    return
                }
                
                // Present LinkPromptViewController, send location with it
                let location = results[0]
                self.displayLinkPrompt(location)
            })
        }
        
    }
    
    private func displayLinkPrompt(location: CLPlacemark) {
        // Instantiate link prompt, set the location, and present it
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LinkPrompt") as! LinkPromptViewController
        controller.location = location
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    private func removeNavigationbarBorder() {
        for parent in navBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: Textfield methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
