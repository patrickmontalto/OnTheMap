//
//  OTMDataSource.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//
import Foundation

class OTMDataSource {
    
    // MARK: Properties
    
    // Shared model
    var locations = [Location]()
    var student: Student? = nil
    var location: Location? = nil
    
    // MARK: - Singleton
    class func sharedDataSource() -> OTMDataSource {
        struct Singleton {
            static var sharedInstance = OTMDataSource()
        }
        return Singleton.sharedInstance
    }
    
    func getStudentLocationData() {
        ParseClient.sharedInstance().retrieveLocations { (success, errorString) in
            if success {
                self.sendNotification("studentLocationsSuccess")
            } else {
                self.sendNotification("studentLocationsError")
            }
        }
    }
    
    private func sendNotification(notificationName: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
}
