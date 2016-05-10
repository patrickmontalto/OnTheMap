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
    let uniqueKey: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    var location: Location
}