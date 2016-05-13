//
//  Location.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import MapKit

// MARK: - Location Model

struct Location {
    
    // MARK: Location Properties
    
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectID: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    // MARK: Student Properties
    let firstName: String
    let lastName: String
    let uniqueKey: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: Custom Init
    
    init(jsonDictionary: [String:AnyObject]) {
        self.longitude = jsonDictionary[ParseClient.JSONKeys.Longitude] as! Double
        self.latitude = jsonDictionary[ParseClient.JSONKeys.Latitude] as! Double
        self.mapString = jsonDictionary[ParseClient.JSONKeys.MapString] as! String
        self.mediaURL = jsonDictionary[ParseClient.JSONKeys.MediaURL] as! String
        self.objectID = jsonDictionary[ParseClient.JSONKeys.ObjectID] as! String
        
        self.firstName = jsonDictionary[ParseClient.JSONKeys.FirstName] as! String
        self.lastName = jsonDictionary[ParseClient.JSONKeys.LastName] as! String
        self.uniqueKey = jsonDictionary[ParseClient.JSONKeys.UniqueKey] as! String
        
    }
}
