//
//  GoogleAnalyticsEvents.swift
//  Photo Trasher
//
//  Created by Aleksander Hindenes on 29/07/15.
//  Copyright (c) 2015 Simen Johannessen. All rights reserved.
//

import Foundation

struct GoogleAnalyticsEvents {
    static let tracker = GAI.sharedInstance().defaultTracker
    
    private static let DATA = "data"
    private static let AFTER_DELETE = "after_delete"
    
    static func numberOfDeletedPhotos(numberOfDeletedPhotos: Int) {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory(DATA, action: AFTER_DELETE, label: "photos_deleted", value: numberOfDeletedPhotos).build() as [NSObject : AnyObject])
    }
    
    static func megabytesDeleted(megabytesDeleted: Int) {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory(DATA, action: AFTER_DELETE, label: "magabytes_deleted", value: megabytesDeleted).build() as [NSObject : AnyObject])
    }
    
    static func goBackButtonPressed() {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("button_pressed", action: "go_back_to_start", label: "", value: nil).build() as [NSObject : AnyObject])
    }
    
    static func postOnTwitterButtonPressed() {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("button_pressed", action: "post_on_twitter", label: "", value: nil).build() as [NSObject : AnyObject])
    }
    
    static func postOnFacebookButtonPressed() {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("button_pressed", action: "post_on_facebook", label: "", value: nil).build() as [NSObject : AnyObject])
    }
    
    static func userPostedOnFacebook() {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("button_pressed", action: "completed_post_on_facebook", label: "", value: nil).build() as [NSObject : AnyObject])
    }
    
    static func userPostedOnTwitter() {
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("button_pressed", action: "completed_post_on_twitter", label: "", value: nil).build() as [NSObject : AnyObject])
    }
}