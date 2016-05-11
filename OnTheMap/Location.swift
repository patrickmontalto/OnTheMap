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
}
