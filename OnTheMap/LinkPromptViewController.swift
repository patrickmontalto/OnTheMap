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
    var location: CLPlacemark! = nil
    var newLocation: Location!
    
    @IBOutlet var linkTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPlacemark(placemark: location)
        mapView.showAnnotations([annotation], animated: true)
        linkTextField.delegate = self
    }
    
    @IBAction func cancelPrompt(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitStudentLocation(sender: AnyObject) {
        /* GUARD: is there a media URL entered in the text field? */
        guard let mediaURL = linkTextField.text where linkTextField.text != nil else {
            // TODO: displayError(Please enter a link into the field.")
            return
        }
        // TODO: Execute method to post student location, handle success and errors
        
        
        // Get HTTPBody values for request
        // CASE: currentStudent has location: We need to use a different method, same parameters. Just use ObjectID in URL
        var mapString: String? = nil
        
        /* GUARD: Does the current location have a locality and an administrative area? */
        if let locality = self.location.locality, let administrativeArea = self.location.administrativeArea {
            mapString = "\(locality), \(administrativeArea)"
        }
        
        /* GUARD: Is there a current student? */
        guard let student = OTMDataSource.sharedDataSource().student else {
            // TODO: Display Error: User not logged in.
            return
        }
        
        
        if student.hasStoredLocation() {
            let objectID = OTMDataSource.sharedDataSource().location!.objectID
            // Call ParseClient.updateStudentLocation(student: student, mapString: mapString, objectID: objectID)
        } else {
            // Call ParseClient.postStudentLocation(student: student, mapString: mapString)
        }
        
        
        
        
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(OTMDataSource.sharedDataSource().location?.objectID)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(OTMDataSource.sharedDataSource().student!.uniqueKey)\", \"firstName\": \"\(OTMDataSource.sharedDataSource().location!.firstName)\", \"lastName\": \"\(OTMDataSource.sharedDataSource().location!.lastName)\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    // MARK: Textfield methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}