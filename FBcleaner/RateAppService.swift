//
//  RateAppService.swift
//  Photo Trasher
//
//  Created by Simen Johannessen on 13/01/15.
//  Copyright (c) 2015 Simen Johannessen. All rights reserved.
//

import Foundation

class RateAppService {
    func isNewVersion () -> Bool {
        let build: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey) as String
        let buildInt = build.toInt()
        
        if (getPreviousBuildThatWasRated() < buildInt) {
            return true;
        } else {
            return false;
        }
    }
    
    func getPreviousBuildThatWasRated () -> Int {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let previousBuildThatWasRated: Int = userDefaults.valueForKeyPath(PREVIOUS_BUILD_THAT_WAS_RATED) as? Int {
            return previousBuildThatWasRated
        } else {
            return -1
        }
    }
    
    func setNewPreviousBuildThatWasRated () {
        if let build: Int = getBuildInt() {
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setInteger(build, forKey: PREVIOUS_BUILD_THAT_WAS_RATED)
        }
    }
    
    func getBuildInt () -> Int? {
        let build: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey) as String
        return build.toInt()
    }
}