//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Patrick on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: - ParseClient: NSObject

class ParseClient: NSObject {
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    // MARK: - Singleton
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    // MARK: - Retrieve 100 last student locations
    func retrieveLocations(completionHandlerForLocations: (success: Bool, errorString: String?) -> Void) {
        // Build headers
        let headers = [HTTPHeaderKeys.ParseApplicationID: Constants.ApplicationID, HTTPHeaderKeys.ParseAPIKey: Constants.APIKey]
        
        // Build parameters
        let parameters: [String:AnyObject] = [ParameterKeys.Limit:ParameterValues.Limit100, ParameterKeys.Order:ParameterValues.UpdatedAtDesc]
        
        // Build request
        guard let request = APIClient().buildRequestWithHTTPMethod(APIClient.Constants.GET, method: Methods.StudentLocation, jsonBody: nil, headers: headers, parameters: parameters, clientType: Constants.ClientType) else {
            completionHandlerForLocations(success: false, errorString: "Request could not be processed.")
            return
        }
        
        // Get locations
        getLocations(request) { (success, locations, errorString) -> Void in
            if success {
                // Store locations upon success
                if let locations = locations {
                    OTMDataSource.sharedDataSource().locations = locations
                }
            }
            completionHandlerForLocations(success: success, errorString: errorString)
        }
    }
    
    // MARK: - Submit Student Location
    func submitStudentLocation(student: Student, location: CLLocation, mapString: String, mediaURL: String, completionHandlerForSubmitLocation: (success: Bool, errorString: String?) -> Void) {
        let firstName = student.firstName
        let lastName = student.lastName
        let uniqueKey = student.uniqueKey
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Build headers
        let headers = [HTTPHeaderKeys.ParseApplicationID: Constants.ApplicationID, HTTPHeaderKeys.ParseAPIKey: Constants.APIKey, HTTPHeaderKeys.ContentType: HTTPHeaderValues.ApplicationJSON]
        
        // Build jsonBody
        let jsonBody = "{\"\(JSONKeys.UniqueKey)\": \"\(uniqueKey)\", \"\(JSONKeys.FirstName)\": \"\(firstName)\", \"\(JSONKeys.LastName)\": \"\(lastName)\",\"\(JSONKeys.MapString)\": \"\(mapString)\", \"\(JSONKeys.MediaURL)\": \"\(mediaURL)\",\"\(JSONKeys.Latitude)\": \(latitude), \"\(JSONKeys.Longitude)\": \(longitude)}"
        
        // Build request
        guard let request = APIClient().buildRequestWithHTTPMethod(APIClient.Constants.POST, method: Methods.StudentLocation, jsonBody: jsonBody, headers: headers, parameters: nil, clientType: Constants.ClientType) else {
            completionHandlerForSubmitLocation(success: false, errorString: "Request could not be processed.")
            return
        }
        
        // POST location
        postLocation(request) { (success, errorString) in
            completionHandlerForSubmitLocation(success: success, errorString: errorString)
        }

    }
    
    // MARK: - Update Student Location
    func updateStudentLocation(student: Student, location: CLLocation, mapString: String, mediaURL: String, objectID: String, completionHandlerForUpdateLocation: (success: Bool, errorString: String?) -> Void) {
        let firstName = student.firstName
        let lastName = student.lastName
        let uniqueKey = student.uniqueKey
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Build headers
        let headers = [HTTPHeaderKeys.ParseApplicationID: Constants.ApplicationID, HTTPHeaderKeys.ParseAPIKey: Constants.APIKey, HTTPHeaderKeys.ContentType: HTTPHeaderValues.ApplicationJSON]
        
        // Build jsonBody
        let jsonBody = "{\"\(JSONKeys.UniqueKey)\": \"\(uniqueKey)\", \"\(JSONKeys.FirstName)\": \"\(firstName)\", \"\(JSONKeys.LastName)\": \"\(lastName)\",\"\(JSONKeys.MapString)\": \"\(mapString)\", \"\(JSONKeys.MediaURL)\": \"\(mediaURL)\",\"\(JSONKeys.Latitude)\": \(latitude), \"\(JSONKeys.Longitude)\": \(longitude)}"
        
        // Build request
        guard let request = APIClient().buildRequestWithHTTPMethod(APIClient.Constants.PUT, method: Methods.StudentLocation + "/\(objectID)", jsonBody: jsonBody, headers: headers, parameters: nil, clientType: Constants.ClientType) else {
            completionHandlerForUpdateLocation(success: false, errorString: "Request could not be processed.")
            return
        }
    
        // PUT Location
        putLocation(request) { (success, errorString) -> Void in
            completionHandlerForUpdateLocation(success: success, errorString: errorString)
        }
    }
    
    // MARK: - POST Location
    private func postLocation(request: NSURLRequest, completionHandlerForPostLocation: (success: Bool, errorString: String?) -> Void) {
        APIClient().taskForRequest(request, clientType: Constants.ClientType) { (results, error) -> Void in
            /* Check for error */
            guard error == nil else {
                completionHandlerForPostLocation(success: false, errorString: "An error occurred posting location.")
                return
            }
            /* Check objectID key */
            guard let objectID = results[JSONKeys.ObjectID] as? String else {
                completionHandlerForPostLocation(success: false, errorString: "An error occurred posting location (Object ID).")
                return
            }
            completionHandlerForPostLocation(success: true,  errorString: nil)
            
        }
    }
    
    // MARK: - PUT Location
    private func putLocation(request: NSURLRequest, completionHandlerForPostLocation: (success: Bool, errorString: String?) -> Void) {
        APIClient().taskForRequest(request, clientType: Constants.ClientType) { (results, error) -> Void in
            /* Check for error */
            guard error == nil else {
                completionHandlerForPostLocation(success: false, errorString: "An error occurred updating location. Perhaps the URL above is invalid?")
                return
            }
            /* Check for updatedAt key */
            guard let _ = results[JSONKeys.UpdatedAt] else {
                completionHandlerForPostLocation(success: false, errorString: "An error occurred updating location (updatedAt key not found).")
                return
            }
            completionHandlerForPostLocation(success: true,  errorString: nil)
            
        }
    }
    
    
    // MARK: - GET Locations
    private func getLocations(request: NSURLRequest, completionHandlerForGetLocations: (success: Bool, locations: [Location]?, errorString: String?) -> Void) {
        APIClient().taskForRequest(request, clientType: Constants.ClientType) { (results, error) in

            /* check for error */
            guard error == nil else {
                completionHandlerForGetLocations(success: false, locations: nil, errorString: "An error occurred getting student locations.")
                return
            }
            
            /* check for results */
            guard let locationsArray = results[JSONKeys.Results] as? [[String:AnyObject]] else {
                completionHandlerForGetLocations(success: false, locations: nil, errorString: "An error occured getting student locations (no results key found).")
                return
            }
            
            /* iterate through locations array */
            var locations = [Location]()
            
            for location in locationsArray {
                /* GUARD: Does the location have a latitude and longitude? */
                guard let latitude = location[JSONKeys.Latitude] as? Double, let longitude = location[JSONKeys.Longitude] as? Double else {
                    continue
                }
                
                /* GUARD: Does the location have a mapString (location name) ? */
                guard let mapString = location[JSONKeys.MapString] as? String else {
                    continue
                }
                /* GUARD: Does the location have a mediaURL? */
                guard let mediaURL = location[JSONKeys.MediaURL] as? String else {
                    continue
                }
                
                /* GUARD: Does the location have a unique student key? */
                guard let uniqueKey = location[JSONKeys.UniqueKey] as? String else {
                    continue
                }
                
                /* GUARD: Does the location have an objectID? */
                guard let objectID = location[JSONKeys.ObjectID] as? String else {
                    continue
                }
                
                /* GUARD: Does the location have a user's first and last name ? */
                guard let firstName = location[JSONKeys.FirstName] as? String, let lastName = location[JSONKeys.LastName] as? String else {
                    continue
                }
                
//                // Add new location to array of locations
//                let location = Location(latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectID: objectID, firstName: firstName, lastName: lastName, uniqueKey: uniqueKey)
                let location = Location(jsonDictionary: location)
                
                // Check to see if the current location is that of the current student
                if let currentStudent = OTMDataSource.sharedDataSource().student where uniqueKey == currentStudent.uniqueKey {
                    locations.insert(location, atIndex: 0)
                    // Set location for current student in Data Source
                    OTMDataSource.sharedDataSource().location = location
                } else {
                    locations.append(location)
                }
            }
            
            completionHandlerForGetLocations(success: true, locations: locations, errorString: nil)
        }
    }
    
    
}