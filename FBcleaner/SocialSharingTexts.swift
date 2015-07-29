//
//  SocialSharingTexts.swift
//  Photo Trasher
//
//  Created by Aleksander Hindenes on 25/05/15.
//  Copyright (c) 2015 Simen Johannessen. All rights reserved.
//


struct FacebookTexts {
    static func sharingText (numDeleted: Int) -> String {
        return "I just deleted \(numDeleted) photos using Photo Trasher: http://apple.co/1IVwUdB"
    }
    
}

struct TwitterTexts {
    static func sharingText (numDeleted: Int) -> String {
        return "I just deleted \(numDeleted) photos using @phototrasherapp http://apple.co/1SyJWkb"
    }
}

struct CommonTexts {
    static func sharingText (numDeleted: Int, megaBytesToClean: Float) -> String {
        
        var size = NSString(format: "%.01f", megaBytesToClean)
        if(size.containsString("-")){
            size = size.substringFromIndex(1)
        }
        
        return "You just cleaned up \(size) MB of space by deleting \(numDeleted) photos!"
    }
}