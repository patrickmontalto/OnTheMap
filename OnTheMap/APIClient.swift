//
//  APIClient.swift
//  OnTheMap
//
//  Created by Patrick on 5/6/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

class APIClient {
    
    // MARK: - Properties
    let session: NSURLSession!
    
    // MARK: - Initializer
    private init() {
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    // MARK: - Declare Singleton
    private static let sharedClient = APIClient()
    
    class func sharedInstance() -> APIClient {
        return sharedClient
    }
    
    // MARK: - Create Request
    func buildRequestWithHTTPMethod(HTTPMethod: String, method: String, jsonBody: NSData? = nil, headers: [String:String]? = nil, parameters: [String:AnyObject]?, clientType: String) -> NSURLRequest {
        
        /* 1. Set the parameters so they can be appended to if necessary */
        let methodParameters = parameters
        
        /* 2. Build the URL, Configure the request */
        let request =  NSMutableURLRequest(URL: URLFromParameters(methodParameters, withPathExtension: method, clientType: clientType))
        
        /* 3. Build the method, headers, and body */
        request.HTTPMethod = HTTPMethod
        
        // check for headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // check for jsonBody
        if let jsonBody = jsonBody {
            request.HTTPBody = jsonBody
        }
        
        return request
    }
    
    // MARK: - Create Task
    func taskForRequest(request: NSURLRequest, clientType: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 4. Make the task from request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // TODO: Create function for SendError
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                // TODO: Display Error "There was an error with your request: \(error)"
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                // TODO: Display Error "Your request returned a status code other than 2xx!"
                return
            }
            
            /* GUARD: Was there any data returned ? */
            guard var data = data else {
                // TODO: Display Error "No data was returned by the request!"
                return
            }
            
            // CHECK for Udacity Client Type 
            
            if clientType == Constants.UdacityClient {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            }
            
            /* 5. Parse the data and use the data (in the completion handler) */
            self.parseDataWithCompletionHandler(data, completionHandlerForParsedData: completionHandlerForGET)
        }
        /* 6. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // create a URL from parameters
    private func URLFromParameters(parameters: [String:AnyObject]?, withPathExtension: String? = nil, clientType: String) -> NSURL {
        // check for UdacityClient type
        if clientType == APIClient.Constants.UdacityClient {
            
            let components = NSURLComponents()
            components.scheme = UdacityClient.Constants.ApiScheme
            components.host = UdacityClient.Constants.ApiHost
            components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
            components.queryItems = [NSURLQueryItem]()
            
            // Add parameters if present
            if let parameters = parameters {
                for (key, value) in parameters {
                    let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                    components.queryItems!.append(queryItem)
                }
            }
            
            return components.URL!
            
        // check for ParseClient type
        } else if clientType == APIClient.Constants.ParseClient {
            // TODO: Set client to ParseClient.self
        }
        
        // TODO: display error for wrong client type sent to function
        return NSURL()
    
    }
    
    private func parseDataWithCompletionHandler(data: NSData, completionHandlerForParsedData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            // TODO: Display error "Could not parse the data as JSON: \(data)"
            // TODO: Call completionHandlerForParsedData with a nil result and an error
        }
        
        completionHandlerForParsedData(result: parsedResult, error: nil)
    }

}