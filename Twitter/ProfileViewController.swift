//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/24/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorInset = UIEdgeInsetsZero

        profileImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
        nameLabel.text = user?.name
        screenNameLabel.text = user?.screenName
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        tweetsCountLabel.text = formatter.stringFromNumber((user?.tweetsCount)!)
        followingCountLabel.text = formatter.stringFromNumber((user?.followingCount)!)
        followersCountLabel.text = formatter.stringFromNumber((user?.followersCount)!)
        
        TwitterClient.sharedInstance.userTimeLineWithParams(user.screenName, params: nil, completion: {(tweets, error) -> () in
            print(self.user.screenName)
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTweetCell", forIndexPath: indexPath) as! UserTweetCell
        cell.tweet = tweets![indexPath.row]
        
        cell.selectionStyle = .Default
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
