//
//  DatePickerView.swift
//  CamCleaner
//
//  Created by Simen Johannessen on 20/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerDelegate {
    func didFinishWithDateSelected(NSDate)
}

class DatePickerView: UIView {
    var datePicker: UIDatePicker
    var finishButton: UIButton
    var delegate: DatePickerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        fatalError( "NSCoding not supported")
    }
    
    init(datePickerFrame: CGRect){
        self.datePicker = UIDatePicker(frame: CGRectMake(0, 20, datePickerFrame.width, 200))
        self.datePicker.date = Date().getNSDate()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.finishButton = UIButton(frame: CGRectMake(3, 3, 80, 31))
        self.finishButton.setTitle("Done", forState: UIControlState.Normal)
        self.finishButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.finishButton.layer.borderColor = UIColor.blackColor().CGColor
        self.finishButton.layer.borderWidth = 1.0
        self.finishButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.finishButton.layer.cornerRadius = 4.0
        
        var lineView = UIView(frame: CGRectMake(0, 35, datePickerFrame.size.width, 1))
        lineView.backgroundColor = UIColor.blackColor()
        
        super.init(frame: datePickerFrame)
        
//        self.layer.borderWidth = 1.5
//        self.layer.borderColor = UIColor.blackColor().CGColor
        
        
        self.finishButton.addTarget(self, action: "finishButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundColor = UIColor.whiteColor()

        self.addSubview(self.datePicker)
        self.addSubview(self.finishButton)
//        self.addSubview(lineView)

    }
    
    func finishButtonPressed(sender: UIButton){
        self.delegate?.didFinishWithDateSelected(self.datePicker.date)
        self.removeFromSuperview()
    }
}