//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Patrick on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation
import UIKit

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
    // MARK: - Retrieve locations
    func retrieveLocations(completionHandlerForLocations: (success: Bool, errorString: String?) -> Void) {
        // Build headers
        let headers = [HTTPHeaderKeys.ParseApplicationID: Constants.ApplicationID, HTTPHeaderKeys.ParseAPIKey: Constants.APIKey]
        
        // Build request
        let request = APIClient().buildRequestWithHTTPMethod(APIClient.Constants.GET, method: Methods.StudentLocation, jsonBody: nil, headers: headers, parameters: nil, clientType: Constants.ClientType)
        
        // Get locations
        getLocations(request) { (success, locations, errorString) -> Void in
            if success {
                // Store locations upon success
                if let locations = locations {
                    OTMDataSource.sharedDataSource().locations = locations
                }
                completionHandlerForLocations(success: success, errorString: errorString)
            }
        }
    }
    
    // MARK: - GET Locations
    private func getLocations(request: NSURLRequest, completionHandlerForGetLocations: (success: Bool, locations: [Location]?, errorString: String?) -> Void) {
        APIClient().taskForRequest(request, clientType: Constants.ClientType) { (results, error) in
//            DEBUGGING */
            print(results)
            /* check for error */
            guard error == nil else {
                completionHandlerForGetLocations(success: false, locations: nil, errorString: "An error occured getting student locations.")
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
                guard let uniqueKey = location[JSONKeys.uniqueKey] as? String else {
                    continue
                }
                
                /* GUARD: Does the location have a user's first and last name ? */
                guard let firstName = location[JSONKeys.FirstName] as? String, let lastName = location[JSONKeys.LastName] as? String else {
                    continue
                }
                
                // TODO: Add a new student ?
                
                // Add new location to array of locations
                let location = Location(latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, firstName: firstName, lastName: lastName, uniqueKey: uniqueKey)
                locations.append(location)
            }
            completionHandlerForGetLocations(success: true, locations: locations, errorString: nil)
        }
    }
    
}