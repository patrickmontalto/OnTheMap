//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

// MARK: - ListViewController: UITableViewController

class ListViewController: UITableViewController {
    
    @IBOutlet var locationsTableView: UITableView!
    var activityView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add activityView indicator
        configureActivityView()
        
        // Observer for refresh button on student locations
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsWillUpdate", name: "studentLocationsUpdating", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidUpdate", name: "studentLocationsSuccess", object: nil)
    }
    
    // MARK: - tableView methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMDataSource.sharedDataSource().locations.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let location = OTMDataSource.sharedDataSource().locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationCell") as UITableViewCell!
        cell.textLabel?.text = location.fullName
        cell.detailTextLabel?.text = location.mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mediaURLString = OTMDataSource.sharedDataSource().locations[indexPath.row].mediaURL
        
        if let mediaURL = NSURL(string: mediaURLString) {
            if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                UIApplication.sharedApplication().openURL(mediaURL)
            } else {
                displayAlert("Unable to open URL.")
            }
        }
    }
    
    // MARK: - Call this function when student locations begin to be refreshed.
    func studentLocationsWillUpdate() {
        setUIenabled(false)
    }
    
    // MARK: - Call this function when student locations are refreshed.
    func studentLocationsDidUpdate() {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.locationsTableView.reloadData()
            self.setUIenabled(true)
        }
        
    }
    
    // MARK: Configure activityView
    func configureActivityView(){
        activityView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityView.color = OTMConstants.DarkBlueColor
        activityView.center =  CGPoint(x: self.view.center.x, y: self.view.center.y - 44)
        self.view.addSubview(activityView)
    }
    
    // MARK: Toggle UI Interaction
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
            // Show/hide tableView
            if enabled {
                self.locationsTableView.alpha = 1.0
            } else {
                self.locationsTableView.alpha = 0.3
            }
        }
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
