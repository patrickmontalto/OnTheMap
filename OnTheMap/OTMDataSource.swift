//
//  OTMDataSource.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

class OTMDataSource {
    
    // MARK: Properties
    
    // Shared model
    var locations = [Location]()
    
    // MARK: - Singleton
    class func sharedDataSource() -> OTMDataSource {
        struct Singleton {
            static var sharedInstance = OTMDataSource()
        }
        return Singleton.sharedInstance
    }
    
    func getStudentLocationData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        ParseClient.sharedInstance().retrieveLocations { (success, errorString) in
            completionHandler(success: success, errorString: errorString)
        }
    }
}
