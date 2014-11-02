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


class StartViewController: UIViewController {
    var assetsLeftToEvaluate: [PHAsset] = []
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var date = Date()
        self.dateLabel.text = date.getDate()
        self.datePicker.hidden = true
        self.startDate.hidden = true
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
            self.fromDateButton.setTitle("from date", forState: UIControlState.Normal)
        }
        else {
            self.datePicker.hidden = true
            self.startDate.hidden = true
            self.fromDateButton.setTitle("from date", forState: UIControlState.Normal)

        }
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
                        let alertController = UIAlertController(title: "No pictures", message:
                            "It appears that you have no pictures newer than the selected date", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Select new date", style: UIAlertActionStyle.Default, handler: { action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        self.presentViewController(alertController, animated: true, completion: nil);
                    }
                    else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil);
                        let vc = storyboard.instantiateViewControllerWithIdentifier("ViewController") as ViewController;
                        vc.assetsLeftToEvaluate = self.assetsLeftToEvaluate
                        self.presentViewController(vc, animated: true, completion: nil);
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
    
//    
//    if(self.assetsLeftToEvaluate.count == 0){
//    self.labelNoImages.text = "It appears that there is no pictures newer than \(Date().getDateStringFromNSDate(self.fromDate!))"
//    }
}

