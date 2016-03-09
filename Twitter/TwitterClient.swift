//
//  TwitterClient.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/14/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "7Lbf3rWaKc6PxntYrudMK1GBD"
let twitterConsumerSecret = "pG1wBRiZFt4vZ2QzfqarQbHgR1quH5c9BiITHbsoe7QYQY3aQt"

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting home timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func userTimeLineWithParams(screen_name: String?, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/user_timeline.json?screen_name=\(screen_name!)&count=20", parameters: params, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting user timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to get the request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
                    success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        print("User: \(user.name)")
                        self.loginCompletion!(user: user, error: nil)
                },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("Error getting current user")
                    }
                )
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to get the access token: \(error)")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func createFavorite(id: String) {
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Create a favorite")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error creating a favorite")
            }
        )
    }
    
    func destroyFavorite(id: String) {
        TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Destroy a favorite")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error destroying a favorite")
            }
        )
    }
    
    func tweet(message: String) {
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json?status=\(message)", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Tweet")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error Tweeting")
            }
        )
    }
    
    func retweet(id: String) {
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Retweet")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error retweeting")
            }
        )
    }
    
    func unretweet(id: String) {
        TwitterClient.sharedInstance.POST("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Unretweet")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error unretweeting")
            }
        )
    }
    
}
