//
//  Student.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

// MARK: - Student Model

struct Student {
    
    // MARK: Properties
    let firstName: String
    let lastName: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    let uniqueKey: String
    
    func hasStoredLocation() -> Bool {
        let userKeys = OTMDataSource.sharedDataSource().locations.map() { $0.uniqueKey }
        return userKeys.contains(self.uniqueKey)
    }
}