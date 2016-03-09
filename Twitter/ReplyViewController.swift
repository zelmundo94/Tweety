//
//  replyViewController.swift
//  Twitter
//
//  Created by Denzel Keter on 2/23/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    
    var screenName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.text = "@\(screenName) "
        charsLeftLabel.text = "\(140 - textView.text.characters.count)"
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
            textView.text = "@\(screenName) "
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
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
    
    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onReply(sender: AnyObject) {
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
            navigationController?.popToRootViewControllerAnimated(true)
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
