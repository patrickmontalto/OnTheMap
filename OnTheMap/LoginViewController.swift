//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func loginPressed(sender: AnyObject) {
        /* GUARD: is the username entered in? */
        guard let username = usernameField.text, let password = passwordField.text where username != "" && password != "" else {
            alertForInvalidCredentials()
            return
        }
        // Authenticate
        UdacityClient.sharedInstance().authenticateWithUdacity(username, password: password) { (success, errorString) -> Void in
            if success {
                self.completeLogin()
            } else {
                self.alertForInvalidCredentials()
            }
        }
    }
    
    // MARK: - Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("OTMNavigationController") as! UINavigationController
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.presentViewController(controller, animated: true, completion: nil)})
    }
    
    
    func alertForInvalidCredentials() {
        performUIUpdatesOnMain { 
            let alert = UIAlertController(title: "Oops", message: "Invalid username or password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Textfield methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordField {
            loginPressed(self)
        }
        return true
    }
    
    // MARK: Display Alert
    
    private func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: completionHandler))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}


