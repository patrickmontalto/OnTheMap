//
//  UIViewControllerConvenience.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/12/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: Display Alert
    
    func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: completionHandler))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // Hide keyboard when touch outside of textfield
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}