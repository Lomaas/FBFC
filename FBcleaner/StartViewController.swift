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
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var selectFromDate: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    required init(coder aDecoder: NSCoder) {
        self.assetsLeftToEvaluate = []
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var mainBackGround: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.text = Date().getDate()
        self.datePicker.hidden = true
        self.startDate.hidden = true

        self.selectAllButton.layer.borderColor = BLUE_COLOR.CGColor
        self.selectAllButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.selectAllButton.layer.borderWidth = 6.0
        self.selectAllButton.layer.cornerRadius = 3.0
        
        self.selectFromDate.layer.borderColor = BLUE_COLOR.CGColor
        self.selectFromDate.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.selectFromDate.layer.borderWidth = 6.0
        self.selectFromDate.layer.cornerRadius = 3.0
        
        self.startButton.layer.borderColor = BLUE_COLOR.CGColor
        self.startButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        self.startButton.layer.borderWidth = 3.0
        self.startButton.layer.cornerRadius = 3.0

    }
    
    override func viewDidAppear(animated: Bool) {
        self.assetsLeftToEvaluate = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startFromDateButtonPressed(sender: AnyObject) {
        self.fetchAssets(true);
    }
    
    @IBAction func fromDateButtonPressed(sender: AnyObject) {
        if(self.datePicker.hidden != false){
            self.datePicker.hidden = false
            self.startDate.hidden = false
            self.datePicker.date = Date().getNSDate()
            self.fromDateButton.setTitle("FROM DATE", forState: UIControlState.Normal)
        }
        else {
            self.datePicker.hidden = true
            self.startDate.hidden = true
            self.fromDateButton.setTitle("FROM DATE", forState: UIControlState.Normal)

        }
    }
    
    @IBAction func allPicturesButtonPressed(sender: AnyObject) {
        self.fetchAssets(false)
    }
    func fetchAssets(dateCompare: Bool){
        if let results = PHAsset.fetchAssetsWithMediaType(.Image, options: nil) {
            if(dateCompare){
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
                        self.createAlertView("No pictures", message:"It appears that you have no pictures. Take some pictures", actionTitle: "Take some pictures!")
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
        var dateComparisionResult: NSComparisonResult = asset.creationDate.compare(self.datePicker.date)
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

