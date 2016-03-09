//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Denzel Ketter on 2/23/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        textView.delegate = self
        if (textView.text == "") {
            textViewDidEndEditing(textView)
        }
        let tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Tweet something!"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.textColor == UIColor.lightGrayColor()){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        checkRemainingCharacters()
    }
    
    func checkRemainingCharacters() {
        let allowedChars = 140
        let charsInTextView = textView.text.characters.count
        let remainingChars = allowedChars - charsInTextView
        charsLeftLabel.text = "\(remainingChars)"
        if remainingChars <= 10 {
            charsLeftLabel.textColor = UIColor.redColor()
        } else if remainingChars <= 20 {
            charsLeftLabel.textColor = UIColor.orangeColor()
        } else {
            charsLeftLabel.textColor = UIColor.blackColor()
        }
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        let allowedChars = 140
        let charsInTextView = textView.text.characters.count
        let remainingChars = allowedChars - charsInTextView
        if remainingChars < 0 {
            let alert = UIAlertController(title: "Too many words in this tweet.", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var message = textView.text!.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            message = message.stringByReplacingOccurrencesOfString("#", withString: "%23", options: NSStringCompareOptions.LiteralSearch, range: nil)
            message = message.stringByReplacingOccurrencesOfString("'", withString: "%27", options: NSStringCompareOptions.LiteralSearch, range: nil)
            TwitterClient.sharedInstance.tweet(message)
            dismissViewControllerAnimated(true, completion: nil)
        }
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
