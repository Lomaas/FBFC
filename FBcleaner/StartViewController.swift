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
    var date: NSDate
    var dateCompare: Bool = false
    var datePickerView: DatePickerView

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var allCheckBox: UIImageView!
    @IBOutlet weak var fromDateView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    required init(coder aDecoder: NSCoder) {
        self.assetsLeftToEvaluate = []
        self.date = Date().getNSDate()
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth = screenRect.size.width
        var screenHeight = screenRect.size.height
        self.datePickerView = DatePickerView(datePickerFrame: CGRectMake(0, screenHeight - 237, screenWidth, 237))

        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var fromDateImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BACKGROUND_COLOR
        self.startButton.layer.borderColor = GREEN_COLOR.CGColor
        self.startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.startButton.backgroundColor = GREEN_COLOR
        self.startButton.layer.borderWidth = 4.0
        self.startButton.layer.cornerRadius = 3.0
        
        self.dateLabel.text = "Last run \(Date().getDate())"
        var dateStr: String = Date().getDate()
        if(dateStr == "never"){
            dateStr = "Select date"
        }
        self.dateButton.setTitle(Date().getDate(), forState: UIControlState.Normal)
        self.date = Date().getNSDate()
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func touchDown(reconginzer: UILongPressGestureRecognizer){
        
    }
    
    func allViewTapped(recognizer : UIPinchGestureRecognizer){
        self.setAllImagesView()
        self.animateDateViewInvisible()
    }
    
    func fromDateViewTapped(recognizer : UIPinchGestureRecognizer){
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
    
    @IBAction func startFromDateButtonPressed(sender: AnyObject) {
        self.fetchAssets();
    }
    
    @IBAction func dateButtonPressed(sender: AnyObject) {
        self.setFromDateView()
        self.datePickerView.delegate = self
        self.animateDateViewVisible()
    }
    
    func animateDateViewVisible(){
//        var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        var effect = UIVisualEffectView(effect: blur)
//        self.view.addSubview(effect)
        
        if(self.datePickerView.isDescendantOfView(self.view)){
            return
        }
        
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth = screenRect.size.width
        var screenHeight = screenRect.size.height
        self.datePickerView.frame = CGRectMake(0, screenHeight + 237, screenWidth, 237)
        self.view.addSubview(self.datePickerView)

        UIView.animateWithDuration(0.30,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.datePickerView.frame = CGRectMake(0, screenHeight - 237, screenWidth, 237)
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
        self.view.addSubview(self.datePickerView)
        
        UIView.animateWithDuration(0.30,
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
                        self.createAlertView("Unable to find any pictures", message: "It appears that you have no pictures. Take some pictures", actionTitle: "Ok")
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
                        self.createAlertView("Unable to find any pictures", message: "It appears that you have no pictures newer than the selected date", actionTitle: "Select new date")
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
    
    func didFinishWithDateSelected(date: NSDate){
        self.date = date
        self.dateButton.setTitle( Date().getDateStringFromNSDate(date), forState: UIControlState.Normal)
        self.animateDateViewInvisible()
    }
    
    
//    func cameraPressed(reconginzer: UIPinchGestureRecognizer){
//        var screenRect = UIScreen.mainScreen().bounds
//        var screenWidth = screenRect.size.width
//        var screenHeight = screenRect.size.height
//        
//        var flashView = UIView(frame: CGRectMake(self.cameraImage.center.x, self.cameraImage.frame.origin.y, 1, 1))
//        flashView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(flashView)
//        
//        UIView.animateWithDuration(0.1,
//            delay: 0,
//            options: UIViewAnimationOptions.CurveLinear,
//            animations: {
//                self.cameraImage.frame = CGRectMake(self.cameraImage.frame.origin.x, self.cameraImage.frame.origin.y + 15, self.cameraImage.frame.width, self.cameraImage.frame.height)
//            },
//            completion: { finished in
//                UIView.animateWithDuration(0.1,
//                    delay: 0,
//                    options: UIViewAnimationOptions.CurveLinear,
//                    animations: {
//                        self.cameraImage.frame = CGRectMake(self.cameraImage.frame.origin.x, self.cameraImage.frame.origin.y, self.cameraImage.frame.width, self.cameraImage.frame.height)
//                    },
//                    completion: { finished in
//                        
//                })
//        })
//        
//        
//        UIView.animateWithDuration(0.20,
//            delay: 0,
//            options: UIViewAnimationOptions.CurveLinear,
//            animations: {
//                flashView.frame = CGRectMake(0, 0, screenWidth, self.cameraImage.frame.height * 2)
//            },
//            completion: { finished in
//                flashView.removeFromSuperview()
//        })
//    }

}

