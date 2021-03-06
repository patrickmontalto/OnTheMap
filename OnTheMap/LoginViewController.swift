//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    //@IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    @IBOutlet var facebookLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func loginPressed(sender: AnyObject) {
        // Make UI inactive and show activity indicator
        setUIenabled(false)
        /* GUARD: is the username entered in? */
        guard let username = usernameField.text, let password = passwordField.text where username != "" && password != "" else {
            setUIenabled(true)
            alertForInvalidCredentials()
            return
        }
        
        // Authenticate
        UdacityClient.sharedInstance().authenticateWithUdacity(username, password: password) { (success, errorString) -> Void in
            
            // Re-enable UI
            self.setUIenabled(true)
            
            if success {
                self.completeLogin()
            } else if Reachability.isConnectedToNetwork(){
                self.alertForInvalidCredentials()
            } else {
                self.displayAlert("No network connection detected.")
            }
        }
    }
    @IBAction func signUpPressed(sender: AnyObject) {
        // Check connection
        if Reachability.isConnectedToNetwork() {
            if let signupURL = NSURL(string: UdacityClient.Constants.SignupURL) {
                UIApplication.sharedApplication().openURL(signupURL)
            } else {
                displayAlert("Error accessing Udacity signup page.")
            }
        } else {
            displayAlert("No network connection detected.")
        }
    }
    
    // MARK: - Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("OTMNavigationController") as! UINavigationController
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.presentViewController(controller, animated: true, completion: nil)})
    }
    
    // MARK: - Toggle UI Interaction
    func setUIenabled(enabled: Bool) {
        performUIUpdatesOnMain {
            for view in self.view.subviews {
                view.userInteractionEnabled = enabled
            }
            // start or stop activity view
            if self.activityView.isAnimating() {
                self.activityView.stopAnimating()
            } else {
                self.activityView.startAnimating()
            }
        }
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

}

// MARK: - Facebook Login

extension LoginViewController {
    
    @IBAction func loginWithFacebook(sender: AnyObject) {
        // Disable UI
        setUIenabled(false)
        
        // Login through Facebook
        FBSDKLoginManager().logInWithReadPermissions(["public_profile"]) { (result, error) in
            
            // Check for error
            if error != nil {
                // Re-enable UI
                self.setUIenabled(true)
                
                self.displayAlert("Error logging in through Facebook.")
                
            } else if result.isCancelled {
                // Re-enable UI
                self.setUIenabled(true)
                
                self.displayAlert("Cancelled Facebook Login.")
                
            } else {                
                UdacityClient.sharedInstance().authenticateWithFacebook({ (success, errorString) in
                    // Re-enable UI
                    self.setUIenabled(true)
                    
                    // Check for success case
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayAlert("Could not authenticate with Udacity")
                    }
                    
                })
            }
        }
    }

}



