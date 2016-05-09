//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/6/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: - Facebook App ID
        static let FacebookAppID = 365362206864879
        
        // MARK: - URLS
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        static let ClientType = APIClient.Constants.UdacityClient
    }
    
    
    // MARK: - API Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSession = "/session"
        
        // MARK: Get Public User Data
        static let PublicUserData = "/users"
    }
    
    // MARK: - HTTP Header Keys
    struct HTTPHeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XSRFToken = "X-XSRF-TOKEN"
    }
    
    // MARK: - HTTP Headers Values
    struct HTTPHeaderValues {
        static let ApplicationJSON = "application/json"
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: - General
        static let Status = "status"
        static let Error = "error"
        
        // MARK: - Authorization
        static let Account = "account"
        static let Registered = "registered"
        static let UserKey = "key"
        static let Session = "session"
        static let SessionID = "id"
    }
    
    // MARK: - JSON Response Values
    struct JSONResponseValues {
        // MARK: - Authentication
        static let UserRegistered = true
    }
}