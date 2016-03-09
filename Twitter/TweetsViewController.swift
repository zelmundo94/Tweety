//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/16/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    var imageSelected: UIImageView?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: {(tweets, error) -> () in
            self.tweets = tweets
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "profileImageTapped:")
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.addGestureRecognizer(tapGesture)
        cell.profileImageView.userInteractionEnabled = true
        
        cell.selectionStyle = .Default
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: {(tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl.endRefreshing()
    }
    
    func profileImageTapped(sender: UIGestureRecognizer) {
        imageSelected = sender.view as? UIImageView
        self.performSegueWithIdentifier("segueForProfile", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueForDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        }
        if segue.identifier == "segueForProfile" {
            let tweet = tweets![(imageSelected?.tag)!]
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = tweet.user
        }
    }

}
