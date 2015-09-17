
//
//  Date.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 02/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation

class Date: NSString {
    func getDate() -> String {
        var returnValue: String? = NSUserDefaults.standardUserDefaults().objectForKey(DATE_STRING) as? String
        if returnValue == nil
        {
            returnValue = "- never"
        }
        return returnValue!
    }
    func setDate (newValue: String) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: DATE_STRING)
            NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setDateFromNSDate(newValue: NSDate){
        self.setDate(self.getDateStringFromNSDate(newValue))
    }
    
    func getNSDate() -> NSDate {
        if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey(DATE_STRING) as? String {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            return formatter.dateFromString(returnValue)!
        }
        return NSDate()
    }

    func getDateStringFromNSDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter.stringFromDate(date)
    }
    
}
