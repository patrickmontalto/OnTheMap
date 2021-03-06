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
    //@IBOutlet var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove border of nav bar
        removeNavigationbarBorder()
        // Set delegate for text field
        locationTextView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // set Navbar colors
        setNavbarColors(self, barColor: OTMConstants.GreyColor, textColor: OTMConstants.BlueColor)
    }
    
    @IBAction func cancelPrompt(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
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
    
    private func setNavbarColors(controller: UIViewController, barColor: UIColor, textColor: UIColor) {
        controller.navigationController?.navigationBar.barTintColor = barColor
        controller.navigationController?.navigationBar.tintColor = textColor
        
    }
    
    private func displayLinkPrompt(location: CLPlacemark) {
        // Instantiate link prompt, set the location, and present it
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LinkPrompt") as! LinkPromptViewController
        controller.locationPlacemark = location
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    private func removeNavigationbarBorder() {
        for parent in (self.navigationController?.navigationBar.subviews)! {
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
}
