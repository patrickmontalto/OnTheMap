//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation


// MARK: - UdacityClient: NSObject 

class UdacityClient: NSObject {
    
    // MARK: - Properties
    // authentication state
    var sessionID: String? = nil
    var userKey: Int? = nil
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
    
    // MARK: - Singleton
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - Authenticate
    func authenticateWithUdacity(username: String, password: String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        // Build JSON body
        let jsonBody = "{\"udacity\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
    
        // Build HTTP headers
        let headers = [HTTPHeaderKeys.Accept: HTTPHeaderValues.ApplicationJSON, HTTPHeaderKeys.ContentType: HTTPHeaderValues.ApplicationJSON]

        // Build request
        let request = APIClient().buildRequestWithHTTPMethod(APIClient.Constants.POST, method: Methods.AuthenticationSession, jsonBody: jsonBody, headers: headers, parameters: nil, clientType: Constants.ClientType)

        // Get session ID
        getSessionID(request) { (success, userKey, sessionID, errorString) in
            if success {
                if let userKey = userKey, sessionID = sessionID {
                    // Store the sessionID and userKey upon success!
                    self.sessionID = sessionID
                    self.userKey = Int(userKey)
                }
            }
            completionHandlerForAuth(success: success, errorString: errorString)
        }
    }
    
    // MARK: - Logout
    func logout(completionHandler: (success: Bool, errorString: String?) -> Void) {
        // Build HTTP header
        var xsrfCookie: NSHTTPCookie? = nil
        var headers = [String:String]()
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            headers = ["X-XSRF-TOKEN":xsrfCookie.value]
        }
        
        // Build request
        let request = APIClient().buildRequestWithHTTPMethod(APIClient.Constants.DELETE, method: Methods.AuthenticationSession, jsonBody: nil, headers: headers, parameters: nil, clientType: Constants.ClientType)
        
        // Create and start task
        deleteSession(request) { (success, errorString) -> Void in
            if success {
                self.sessionID = nil
                self.userKey = nil
            }
            completionHandler(success: success, errorString: errorString)
        }
        
    }
    
    // MARK: - Get Session ID
    func getSessionID(request: NSURLRequest, completionHandlerForSessionID: (success: Bool, userKey:String?, sessionID: String?, errorString: String?) -> Void) {
        
        // Make the request
        APIClient().taskForRequest(request, clientType: Constants.ClientType) { (results, error) in
            
            /* check for error */
            if let error = error {
                completionHandlerForSessionID(success: false, userKey: nil, sessionID: nil, errorString: "Login failed (session ID)")
            } else {
                if let account = results[JSONResponseKeys.Account] as? [String:AnyObject], let userKey = account[JSONResponseKeys.UserKey] as? String {
                    if let session = results[JSONResponseKeys.Session] as? [String:AnyObject], let sessionID = session[JSONResponseKeys.SessionID] as? String {
                        completionHandlerForSessionID(success: true, userKey: userKey, sessionID: sessionID, errorString: nil)
                    } else {
                        completionHandlerForSessionID(success: false, userKey: nil, sessionID: nil, errorString: "Login failed (session ID)")
                    }
                
                } else {
                    completionHandlerForSessionID(success: false, userKey: nil, sessionID: nil, errorString: "Login failed (Account)")
                }
            }
            
        }
    }
    
    // MARK: - Logout Request
    func deleteSession(request: NSURLRequest, completionHandlerForLogout: (success: Bool, errorString: String?) -> Void) {
        
        // Make the request
        APIClient().taskForRequest(request, clientType: Constants.ClientType) { (results, error) -> Void in
            
            /* check for error */
            guard error == nil else {
                completionHandlerForLogout(success: false, errorString: "An error occurred logging out of Udacity.")
                return
            }
            
            /* check for success case */
            guard let session = results[JSONResponseKeys.Session] as? [String:AnyObject] else {
                completionHandlerForLogout(success: false, errorString: "Logout failed. Key \(JSONResponseKeys.Session) not found in results.")
                return
            }
            
            completionHandlerForLogout(success: true, errorString: nil)
        }
    }
    
}