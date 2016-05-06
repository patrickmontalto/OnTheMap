//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation


// MARK: - UdacityClient: NSObject 

class UdacityClient {
    
    // MARK: - Properties
    let apiClient: APIClient
    
    // authentication state
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: - Initializer
    private init() {
        apiClient = APIClient.sharedInstance()
    }
    
    // MARK: - Declare Singleton
    
    private static let sharedInstance = UdacityClient()
    
    class func sharedSession() -> NSURLSession {
        return sharedInstance.apiClient.session
    }
    
    // MARK: - Authenticate
    func authenticateWithUdacity(username: String, password: String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        // Build JSON body
        let jsonBody = "{\"udacity\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build HTTP headers
        let headers = [HTTPHeaderKeys.Accept: HTTPHeaderValues.ApplicationJSON, HTTPHeaderKeys.ContentType: HTTPHeaderValues.ApplicationJSON]
        
        // Build request
        let request = APIClient.sharedInstance().buildRequestWithHTTPMethod(APIClient.Constants.POST, method: Methods.AuthenticationSession, jsonBody: jsonBody, headers: headers, parameters: nil, clientType: Constants.ClientType)
        
        // Get session ID
        getSessionID(request) { (success, sessionID, errorString) in
            if success {
                // Store the sessionID upon success!
                self.sessionID = sessionID
            }
            completionHandlerForAuth(success: success, errorString: errorString)
        }
    }
    
    // MARK: - Get Session ID
    func getSessionID(request: NSURLRequest, completionHandlerForSessionID: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        // Make the request
        APIClient.sharedInstance().taskForRequest(request, clientType: Constants.ClientType) { (results, error) in
            
            /* check for error */
            if let error = error {
                print(error)
                completionHandlerForSessionID(success: false, sessionID: nil, errorString: "Login failed (session ID)")
            } else {
                /* GUARD: Is there a username key in the */
            }
            
        }
    }
    
}