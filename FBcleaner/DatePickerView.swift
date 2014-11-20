//
//  DatePickerView.swift
//  CamCleaner
//
//  Created by Simen Johannessen on 20/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit

class DatePickerView: UIView {
    var datePicker: UIDatePicker
    var finishButton: UIButton
    
    required init(coder aDecoder: NSCoder) {
        fatalError( "NSCoding not supported")
    }
    
    init(datePickerFrame: CGRect){
        self.datePicker = UIDatePicker(frame: CGRectMake(0, 20, datePickerFrame.width, 200))
        self.datePicker.date = Date().getNSDate()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.finishButton = UIButton(frame: CGRectMake(datePickerFrame.width - 100, 0, 100, 50))
        self.finishButton.setTitle("Finished", forState: UIControlState.Normal)
        self.finishButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.finishButton.backgroundColor = UIColor.blackColor()
        self.finishButton.layer.borderColor = UIColor.blueColor().CGColor
        self.finishButton.layer.borderWidth = 2.0
        self.finishButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.finishButton.layer.cornerRadius = 2.0
        
        var lineView = UIView(frame: CGRectMake(0, 20, datePickerFrame.size.width, 1))
        lineView.backgroundColor = UIColor.blackColor()
        
        super.init(frame: datePickerFrame)
        self.finishButton.addTarget(self, action: "finishButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundColor = UIColor.whiteColor()

        self.addSubview(self.datePicker)
        self.addSubview(self.finishButton)
        self.addSubview(lineView)

    }
    
    func finishButtonPressed(sender: UIButton){
        self.removeFromSuperview()
    }
}