
//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import MapKit

// MARK: - MapViewController: UIViewController, MKMapViewDelegate

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsWillUpdate", name: "studentLocationsUpdating", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidUpdate", name: "studentLocationsSuccess", object: nil)
        
        // Populate annotations array and update MapView annotations
        self.mapView.alpha = 0.3
        OTMDataSource.sharedDataSource().getStudentLocationData()
        
    }
    
    // MARK: - Prepare UI for network request
    func studentLocationsWillUpdate() {
        // Disable buttons on tab bar and navbar
        setUIenabled(false)
    }
    
    // MARK: - Call this function when student locations are refreshed.
    
    func studentLocationsDidUpdate() {
        // Create array of MKPointAnnotations
        var annotations = [MKPointAnnotation]()
        
        // For each dictionary in locations:
        let locations = OTMDataSource.sharedDataSource().locations
        
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Create annotation and set its coordinate, title, and subtitle
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.fullName
            annotation.subtitle = location.mediaURL
            
            // Append to annotations array
            annotations.append(annotation)
        }

        // Once the array is complete, remove old annotations and add new annotations to map
        // Need to wait on re-enabling UI...
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            
            self.setUIenabled(true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = OTMConstants.OrangeColor
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            } else {
                displayAlert("Invalid URL")
            }
        }
    }
    
    // MARK: Toggle UI Interaction
    func setUIenabled(enabled: Bool) {
        performUIUpdatesOnMain {
            for view in self.view.subviews {
                view.userInteractionEnabled = enabled
            }
            // start or stop activity view
            if self.activityView.isAnimating() {
                self.activityView.stopAnimating()
            } else {
                self.activityView.startAnimating()
            }
            // Show/hide mapView
            if enabled {
                self.mapView.alpha = 1.0
            } else {
                self.mapView.alpha = 0.3
            }
        }
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