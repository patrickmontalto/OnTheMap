//
//  StringConvenience.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/12/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

extension String {
   
    // Use this method to test for http:// or https:// in location mediaURLs
    
    func beginsWith(prefix: String) -> Bool {
        let size = prefix.characters.count
        let subString = (self as NSString).substringToIndex(size)
        
        return subString == prefix
    }
}