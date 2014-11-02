
//
//  Date.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 02/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation

class Date: NSString {
    func getDate() -> NSString {
        var returnValue: NSString? = NSUserDefaults.standardUserDefaults().objectForKey(DATE_STRING) as? NSString
        if returnValue == nil
        {
            returnValue = "Never"
        }
        return returnValue!
    }
    func setDate (newValue: NSString) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: DATE_STRING)
            NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getNSDate() -> NSDate {
        var returnValue: NSString? = NSUserDefaults.standardUserDefaults().objectForKey(DATE_STRING) as? NSString
        if returnValue == nil
        {
            return NSDate()
        }
        else {
            var formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            return formatter.dateFromString(returnValue!)!
        }
    }
    
    func getDateStringFromNSDate(date: NSDate) -> NSString {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        println(formatter.stringFromDate(date))
        return formatter.stringFromDate(date)
    }
    
}
