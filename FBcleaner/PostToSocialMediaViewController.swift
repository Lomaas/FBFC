//
//  PostToSocialMediaViewController.swift
//  Photo Trasher
//
//  Created by Aleksander Hindenes on 25/05/15.
//  Copyright (c) 2015 Simen Johannessen. All rights reserved.
//

import Social

class PostToSocialMediaViewController: SLComposeViewController {
    
    @IBOutlet weak var textSummary: UILabel!
    
    var numberOfDeletedPhotos: Int?
    var megaBytesToClean: Float?
    var goBackDelegate: GoBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textSummary.text = CommonTexts.sharingText(numberOfDeletedPhotos!, megaBytesToClean: megaBytesToClean!)
    }

    @IBAction func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.goBackDelegate?.dissmissMyViewController(self as UIViewController, toStartView: true, animated: false, title: "Success", msg:"Your pictures were deleted")
    }
    
    @IBAction func postToTwitter() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(TwitterTexts.sharingText(numberOfDeletedPhotos!))
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share. Go to Settings -> Twitter to add a Twitter account", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func postToFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(FacebookTexts.sharingText(numberOfDeletedPhotos!))
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share. Go to Settings -> Facebook to add a Facebook account", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    

}
