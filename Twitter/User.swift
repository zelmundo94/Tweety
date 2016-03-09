//
//  User.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/14/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tweetsCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) {
                    do {
                        if let dictionary = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions(rawValue:0)) as? NSDictionary {
                            _currentUser = User(dictionary: dictionary)
                        }
                    } catch {
                        print("Error parsing JSON")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                do {
                    if let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue:0)) as? NSData {
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    }
                } catch {
                    print("Error wirting to JSON")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
