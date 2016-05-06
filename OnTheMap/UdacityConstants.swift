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
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSessionNew = "/session"
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
        static let Session = "session"
        static let SessionID = "id"
    }
    
    // MARK: - JSON Response Values
    struct JSONResponseValues {
        // MARK: - Authentication
        static let UserRegistered = true
    }
}