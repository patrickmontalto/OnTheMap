//
//  LinkPromptViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import MapKit

class LinkPromptViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    var locationPlacemark: CLPlacemark! = nil
    var newLocation: Location!
    
    @IBOutlet var linkTextField: UITextField!
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPlacemark(placemark: locationPlacemark)
        mapView.showAnnotations([annotation], animated: true)
        linkTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavbarColors(self, barColor: OTMConstants.BlueColor, textColor: OTMConstants.GreyColor)
    }
    
    // TODO: TEMPORARY: Listener for backbutton
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            setNavbarColors(self.parentViewController!, barColor: OTMConstants.GreyColor, textColor: OTMConstants.BlueColor)
        }
    }
    
    @IBAction func submitStudentLocation(sender: AnyObject) {
        
        /* GUARD: Does the current locationPlacemark have a location? */
        guard let location = locationPlacemark.location else {
            displayAlert("Location not found.")
            return
        }
        
        /* GUARD: is there a media URL entered in the text field? */
        guard let mediaURL = linkTextField.text where linkTextField.text != nil else {
            displayAlert("Please enter a link into the field.")
            return
        }
        
        // Build mapString
        
        /* GUARD: Does the current location have a locality and an administrative area? */
        guard let locality = self.locationPlacemark.locality, let administrativeArea = self.locationPlacemark.administrativeArea else {
            displayAlert("Location not found.")
            return
        }
        
        let mapString = "\(locality), \(administrativeArea)"
        
        /* GUARD: Is there a current student? */
        guard let student = OTMDataSource.sharedDataSource().student else {
            displayAlert("User not found.")
            return
        }
        
        // Begin Request
        if student.hasStoredLocation() {
            let objectID = OTMDataSource.sharedDataSource().location!.objectID
            ParseClient.sharedInstance().updateStudentLocation(student, location: location, mapString: mapString, mediaURL: mediaURL, objectID: objectID, completionHandlerForUpdateLocation: { (success, errorString) -> Void in
                self.completionHandlerForStudentLocation(success, errorString: errorString)
            })
         
        } else {
            ParseClient.sharedInstance().submitStudentLocation(student, location: location, mapString: mapString, mediaURL: mediaURL, completionHandlerForSubmitLocation: { (success, errorString) -> Void in
                self.completionHandlerForStudentLocation(success, errorString: errorString)
            })
        }
        
    }
    
    // MARK: Textfield methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setNavbarColors(controller: UIViewController, barColor: UIColor, textColor: UIColor) {
        controller.navigationController?.navigationBar.barTintColor = barColor
        controller.navigationController?.navigationBar.tintColor = textColor
        
    }
    // MARK: Completion handler for student location
    private func completionHandlerForStudentLocation(success: Bool, errorString: String?) {
        performUIUpdatesOnMain() {
            if success {
                // Refresh student locations. dismiss view controller
                OTMDataSource.sharedDataSource().getStudentLocationData()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayAlert(errorString ?? "An error occurred submitting location.")
            }
        }
    }
    
    // MARK: Display Alert
    
    private func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: completionHandler))
            self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}