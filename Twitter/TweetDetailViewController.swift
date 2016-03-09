//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/23/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        let tapGesture = UITapGestureRecognizer(target: self, action: "profileImageTapped:")
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.userInteractionEnabled = true
        nameLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        timeStampLabel.text = tweet.createdAtString
        
        favoriteCountLabel.text = "\(tweet.favouritesCount!)"
        retweetCountLabel.text = "\(tweet.retweetCount!)"
        if (tweet.favorited!) {
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
            favoriteCountLabel.textColor = UIColor.redColor()
        } else {
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
            favoriteCountLabel.textColor = UIColor.grayColor()
        }
        if (tweet.retweeted!) {
            retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
            retweetCountLabel.textColor = UIColor(red:0.1, green:0.72, blue:0.6, alpha:1.0)
        } else {
            retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
            retweetCountLabel.textColor = UIColor.grayColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if (tweet.favorited!) {
            TwitterClient.sharedInstance.destroyFavorite(tweet.id!)
            tweet.favouritesCount!--
            tweet.favorited = false
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
            favoriteCountLabel.textColor = UIColor.grayColor()
        } else {
            TwitterClient.sharedInstance.createFavorite(tweet.id!)
            tweet.favouritesCount!++
            tweet.favorited = true
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
            favoriteCountLabel.textColor = UIColor.redColor()
        }
        favoriteCountLabel.text = "\(tweet.favouritesCount!)"
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if (tweet.retweeted!) {
            TwitterClient.sharedInstance.unretweet(tweet.id!)
            tweet.retweetCount!--
            tweet.retweeted = false
            retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
            retweetCountLabel.textColor = UIColor.grayColor()
        } else {
            TwitterClient.sharedInstance.retweet(tweet.id!)
            tweet.retweetCount!++
            tweet.retweeted = true
            retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
            retweetCountLabel.textColor = UIColor(red:0.1, green:0.72, blue:0.6, alpha:1.0)
        }
        retweetCountLabel.text = "\(tweet.retweetCount!)"
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    func profileImageTapped(gesture: UIGestureRecognizer) {
        self.performSegueWithIdentifier("segueForProfile", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueForReply" {
            let replyViewController = segue.destinationViewController as! ReplyViewController
            replyViewController.screenName = tweet.user?.screenName
        }
        if segue.identifier == "segueForProfile" {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = tweet.user
        }
    }

}
