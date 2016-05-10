
//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidUpdate", name: "studentLocationsSuccess", object: nil)
        
        // Populate annotations array and update MapView annotations
        OTMDataSource.sharedDataSource().getStudentLocationData()
        
    }

    func studentLocationsDidUpdate() {
        // create array of MKPointAnnotations
        var annotations = [MKPointAnnotation]()
        
        // for each dictionary in locations:
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
            
            // append to annotations array
            annotations.append(annotation)
        }

        // once the array is complete, remove old annotations and add new annotations to map:
        performUIUpdatesOnMain {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
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
            pinView!.pinColor = .Purple
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
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
                // TODO: Display "Invalid URL" for invalid URLs
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }

    
}