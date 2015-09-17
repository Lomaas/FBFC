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
    func didFinishWithDateSelected(_: NSDate)
}

class DatePickerView: UIView {
    var datePicker: UIDatePicker
    var finishButton: UIButton
    var delegate: DatePickerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
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
        
        super.init(frame: datePickerFrame)
        
        self.finishButton.addTarget(self, action: "finishButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backgroundColor = UIColor.whiteColor()

        self.addSubview(self.datePicker)
        self.addSubview(self.finishButton)
    }
    
    func finishButtonPressed(sender: UIButton){
        let calendar = NSCalendar.currentCalendar()
        let timeZone = NSTimeZone.systemTimeZone
        calendar.timeZone = timeZone()
        
        let dateComps = calendar.components([.Year, .Month, .Day] , fromDate: self.datePicker.date)
        dateComps.minute = 0
        dateComps.second = 0
        dateComps.hour = 0
        
        self.delegate?.didFinishWithDateSelected(calendar.dateFromComponents(dateComps)!)
    }
}