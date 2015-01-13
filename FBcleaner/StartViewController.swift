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


class StartViewController: UIViewController, GoBackDelegate, DatePickerDelegate {
    var assetsLeftToEvaluate: [PHAsset]
    var allAssets: [PHAsset]
    var date: NSDate
    var dateCompare: Bool
    var datePickerView: DatePickerView

    @IBOutlet weak var navigationitem: UINavigationItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var allCheckBox: UIImageView!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var fromDateImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        self.assetsLeftToEvaluate = []
        self.allAssets = []
        self.date = Date().getNSDate()
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth = screenRect.size.width
        var screenHeight = screenRect.size.height
        self.dateCompare = false
        self.datePickerView = DatePickerView(datePickerFrame: CGRectMake(0, screenHeight - 237, screenWidth, 237))
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePickerView.delegate? = self
        self.view.backgroundColor = BACKGROUND_COLOR
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width * UIScreen.mainScreen().scale
        let screenHeight = screenRect.size.height * UIScreen.mainScreen().scale
        var adjustment = CGFloat(15)

        self.startButton.layer.borderColor = GREEN_COLOR_DARK.CGColor
        self.startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.startButton.backgroundColor = GREEN_COLOR_DARK
        self.startButton.alpha = 1.0
        self.startButton.layer.borderWidth = 4.0
        self.startButton.layer.cornerRadius = 3.0
        
        self.date = Date().getNSDate()
        self.updateDates()

        var singleTap = UITapGestureRecognizer(target: self, action: "allViewTapped:")
        singleTap.numberOfTapsRequired = 1
        var fakeLongPress = TouchDownGestureRecognizer(target: self, action: "touchDown:", parentView: self.allView)

        self.allView.addGestureRecognizer(singleTap)
        self.allView.addGestureRecognizer(fakeLongPress)

        singleTap = UITapGestureRecognizer(target: self, action: "fromDateViewTapped:")
        singleTap.numberOfTapsRequired = 1
        self.fromDateView.addGestureRecognizer(singleTap)
        
        fakeLongPress = TouchDownGestureRecognizer(target: self, action: "touchDown:", parentView: self.fromDateView)
        self.fromDateView.addGestureRecognizer(fakeLongPress)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.assetsLeftToEvaluate = []
        self.allAssets = []
        self.fetchAssets()
        self.dateLabel.text = "Last run \(Date().getDate())"
    }
    
    func updateDates() {
        self.dateLabel.text = "Last run \(Date().getDate())"
        var dateStr: String = Date().getDate()
        if(dateStr.lowercaseString == "- never"){
            dateStr = "Select date"
            self.dateLabel.text = ""
        }
        self.dateButton.setTitle(dateStr, forState: UIControlState.Normal)
        self.date = Date().getNSDate()
        self.datePickerView.datePicker.date = self.date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func touchDown(reconginzer: UILongPressGestureRecognizer) {
        
    }
    
    func allViewTapped(recognizer : UIPinchGestureRecognizer) {
        self.setAllImagesView()
        self.animateDateViewInvisible()
    }
    
    func fromDateViewTapped(recognizer : UIPinchGestureRecognizer) {
        self.setFromDateView()
    }
    
    func setAllImagesView(){
        allCheckBox.image = UIImage(named: "checkedv2")
        self.fromDateImage.image = UIImage(named : "uncheckedv2")
        self.dateCompare = false
    }
    
    func setFromDateView(){
        allCheckBox.image = UIImage(named: "uncheckedv2")
        self.fromDateImage.image = UIImage(named : "checkedv2")
        self.dateCompare = true
    }
    
    @IBAction func dateButtonPressed(sender: AnyObject) {
        self.setFromDateView()
        self.datePickerView.delegate = self
        self.animateDateViewVisible()
    }
    
    func animateDateViewVisible(){
        if(self.datePickerView.isDescendantOfView(self.view)){
            return
        }
        
        var screenRect = UIScreen.mainScreen().bounds
        let adjustment = CGFloat(280)
        self.datePickerView.frame = CGRectMake(0, screenRect.size.height + adjustment, screenRect.size.width, adjustment)
        self.view.addSubview(self.datePickerView)

        UIView.animateWithDuration(0.30,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.datePickerView.frame = CGRectMake(0, screenRect.size.height - adjustment, screenRect.size.width, adjustment)
            },
            completion: { finished in
                
        })
    }
    
    func animateDateViewInvisible(){
        if(!self.datePickerView.isDescendantOfView(self.view)){
            return
        }
        
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth = screenRect.size.width
        var screenHeight = screenRect.size.height
        self.datePickerView.frame = CGRectMake(0, screenHeight - 237, screenWidth, 237)
        
        UIView.animateWithDuration(0.40,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.datePickerView.frame = CGRectMake(0, screenHeight + 237, screenWidth, 237)
            },
            completion: { finished in
                self.datePickerView.removeFromSuperview()
        })
    }
    
    func fetchAssets(){
        var options = PHFetchOptions()
//        options.includeHiddenAssets = true    
//        options.includeAllBurstAssets = true
        
        if let results = PHAsset.fetchAssetsWithMediaType(.Image, options: options) {
            self.evaluateResult(results)
        }
    }
    
    func evaluateResult(results: PHFetchResult){
        results.enumerateObjectsUsingBlock { (object, idx, _) in
            if let asset = object as? PHAsset {
                self.allAssets.append(asset)
            }
        }
    }
    
    func maskAssetsOutByDate(){
        self.assetsLeftToEvaluate = []
        
        for (var i = 0; i < self.allAssets.count; i++){
            var asset = self.allAssets[i]
            
            if(self.compareDates(asset)){
                self.assetsLeftToEvaluate.append(asset)
            }
        }
    }

    func compareDates(asset: PHAsset) -> Bool {        
        let dateComparisionResult: NSComparisonResult = asset.creationDate.compare(self.date)
        if(dateComparisionResult == NSComparisonResult.OrderedDescending || dateComparisionResult == NSComparisonResult.OrderedSame) {
            return true
        }
        return false
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (self.dateCompare == true) {
            self.maskAssetsOutByDate()
        }
        else {
            if (self.allAssets.count == 0) {
                self.fetchAssets()
            }
            self.assetsLeftToEvaluate = self.allAssets
        }
        
        if(self.assetsLeftToEvaluate.count == 0){
            self.createAlertView("Unable to find any photos", message: "It appears that you dont have any photos newer than the selected date", actionTitle: "Select new date")
            self.setFromDateView()
            self.datePickerView.delegate = self
            self.animateDateViewVisible()
            return false
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            if (segue.identifier == "GO_TO_MAIN")
            {
                let vc = segue.destinationViewController as ViewController
                vc.delegate = self
                vc.tmpAssets = self.assetsLeftToEvaluate
            }
    }
    
    func createAlertView(title: NSString, message: NSString, actionTitle: NSString){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dissmissMyViewController(view: UIViewController, toStartView: Bool, animated: Bool, title: String, msg: String){
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func didFinishWithDateSelected(date: NSDate){
        self.date = date
        self.dateButton.setTitle( Date().getDateStringFromNSDate(date), forState: UIControlState.Normal)
        self.animateDateViewInvisible()
    }
}

