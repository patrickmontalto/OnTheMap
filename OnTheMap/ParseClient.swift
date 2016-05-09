//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Patrick on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

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
                if let locations = locations {
                    
                }
            }
        }
    }
    
    // MARK: - GET Locations
    private func getLocations(request: NSURLRequest, completionHandlerForGetLocations: (success: Bool, locations: [[String:AnyObject]]?, errorString: String?) -> Void) {
        
    }
    
}