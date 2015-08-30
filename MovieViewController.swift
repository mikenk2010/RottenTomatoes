//
//  MovieViewController.swift
//  Rotten Tomatoes
//
//  Created by Bao Nguyen on 8/30/15.
//  Copyright (c) 2015 Bao Nguyen. All rights reserved.
//

import UIKit
import AFNetworking
import MRProgress

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var thumbPosterView: UIView!
    
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [NSDictionary]?
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorView.alpha = 0
        
        refreshControl.backgroundColor = UIColor.blackColor()
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        var url = NSURL(string : "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data == nil{
                self.networkErrorView.alpha = 1
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
            }else{
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json{
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                    sleep(3)
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
                }
            }
        })
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pullToReload()
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        pullToReload()
    }
    
    func pullToReload(){
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: false)
        // MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
        var url = NSURL(string : "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            // Hide pull refresh
            self.refreshControl.endRefreshing()
            if data == nil{
                self.networkErrorView.alpha = 1
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
                
                // @Todo: How to hide viewtable,
            }else{
                self.networkErrorView.alpha = 0
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json{
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        
        cell.titleLabel?.text = movie["title"] as? String
        cell.synopsisLabel?.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
        
        movieDetailViewController.movie = movie
        
    }
}
