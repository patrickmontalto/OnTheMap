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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Observer for refresh button on student locations
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ListViewController.studentLocationsDidUpdate), name: "studentLocationsSuccess", object: nil)
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
               // TODO: Display Error: Unable to open URL
            }
        }
    }
    
    // MARK: - Call this function when student locations are refreshed.
    func studentLocationsDidUpdate() {
            self.locationsTableView.reloadData()
    }
    
}
