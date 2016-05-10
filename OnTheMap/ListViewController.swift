//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // TODO: Add observer for studentLocationsSuccess: selector studentLocationsDidUpdate to update table view
    }
    
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
               // TODO: Display Error: Unable to open URL
            }
        }
    }
    
}
