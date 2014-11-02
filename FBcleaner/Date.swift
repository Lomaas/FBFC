
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
    
}
