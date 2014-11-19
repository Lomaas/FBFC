//
//  StartViewController.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 30/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit
import Photos


class StartViewController: UIViewController, GoBackDelegate {
    var assetsLeftToEvaluate: [PHAsset]
    var date: NSDate
    var dateCompare: Bool = false
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var fromDateCheckbox: UIImageView!
    @IBOutlet weak var allCheckBox: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        self.assetsLeftToEvaluate = []
        self.date = Date().getNSDate()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.text = "Last run \(Date().getDate())"
        
        var singleTap = UITapGestureRecognizer(target: self, action: "allViewTapped:")
        singleTap.numberOfTapsRequired = 1
        self.allView.addGestureRecognizer(singleTap)
        singleTap = UITapGestureRecognizer(target: self, action: "fromDateViewTapped:")
        singleTap.numberOfTapsRequired = 1
        self.fromDateView.addGestureRecognizer(singleTap)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.assetsLeftToEvaluate = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func allViewTapped(recognizer : UIPinchGestureRecognizer){
        allCheckBox.image = UIImage(named: "checked")
        fromDateCheckbox.image = UIImage(named : "unchecked")
        self.dateCompare = false
    }
    
    func fromDateViewTapped(recognizer : UIPinchGestureRecognizer){
        allCheckBox.image = UIImage(named: "unchecked")
        fromDateCheckbox.image = UIImage(named : "checked")
        self.dateCompare = true
    }
    
    @IBAction func startFromDateButtonPressed(sender: AnyObject) {
        
        self.fetchAssets();
    }
    
    func fetchAssets(){
        if let results = PHAsset.fetchAssetsWithMediaType(.Image, options: nil) {
            if(self.dateCompare){
                    self.evaluateResultDate(results)
            }
            else {
                self.evaluateResult(results)
            }
        }
    }
    
    func evaluateResult(results: PHFetchResult){
        var counter = 0
        
        results.enumerateObjectsUsingBlock { (object, idx, _) in
            if let asset = object as? PHAsset {
                counter += 1
                self.assetsLeftToEvaluate.append(asset)

                if(counter == results.count){
                    if(self.assetsLeftToEvaluate.count == 0){
                        self.createAlertView("No pictures", message: "It appears that you have no pictures. Take some pictures", actionTitle: "Take some pictures!")
                    }
                    else {
                        self.presentNewViewController()
                    }
                }
            }
        }
    }
    
    func evaluateResultDate(results: PHFetchResult){
        var counter = 0

        results.enumerateObjectsUsingBlock { (object, idx, _) in
            if let asset = object as? PHAsset {
                counter += 1
                
                if(self.compareDates(asset)){
                    self.assetsLeftToEvaluate.append(asset)
                }
       
                if(counter == results.count){
                    if(self.assetsLeftToEvaluate.count == 0){
                        self.createAlertView("No pictures", message: "It appears that you have no pictures newer than the selected date", actionTitle: "Select new date")
                    }
                    else {
                        self.presentNewViewController()
                    }
                }
            }
        }
    }
    
    func compareDates(asset: PHAsset) -> Bool {
        var dateComparisionResult: NSComparisonResult = asset.creationDate.compare(self.date)
        if(dateComparisionResult == NSComparisonResult.OrderedDescending){
            return true
        }
        return false
    }
    
    func presentNewViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("SelecterViewController") as ViewController;
        vc.tmpAssets = self.assetsLeftToEvaluate
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    func createAlertView(title: NSString, message: NSString, actionTitle: NSString){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alertController, animated: true, completion: nil);
    }
    
    func dissmissMyViewController(view: UIViewController, toStartView: Bool, animated: Bool, title: String, msg: String){
        view.dismissViewControllerAnimated(false, completion: { finished in
            self.createAlertView(title, message: msg, actionTitle: "Ok")
        })
    }
}

