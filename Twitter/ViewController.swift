///
//  ViewController.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/14/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
///

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //
            }
        }
    }

}

