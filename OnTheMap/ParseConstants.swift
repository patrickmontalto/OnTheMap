//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Patrick on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
        
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: - URLS
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
        
        static let ClientType = APIClient.Constants.ParseClient
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
  
    // MARK: - HTTP Header Keys
    struct HTTPHeaderKeys {
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let ParseAPIKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    // MARK: - HTTP Headers Values
    struct HTTPHeaderValues {
        static let ApplicationJSON = "application/json"
    }
    
    // MARK: - JSON Keys
    struct JSONKeys {
        
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let UniqueKey = "uniqueKey"
        static let ObjectID = "objectId"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
    }
    
    // MARK: - Parameter Values
    struct ParameterValues {
        static let Limit100 = 100
        static let UpdatedAtDesc = "-updatedAt"
    }
    

}