//
//  StartViewController.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 30/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit


class StartViewController: UIViewController {
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("SelecterViewController") as ViewController;
        vc.fromDate = self.datePicker.date
        self.presentViewController(vc, animated: true, completion: nil);
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
}

