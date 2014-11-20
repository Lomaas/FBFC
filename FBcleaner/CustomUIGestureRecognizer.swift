//
//  CustomUIGestureRecognizer.swift
//  CamCleaner
//
//  Created by Simen Johannessen on 20/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//
import UIKit
import Foundation

class TouchDownGestureRecognizer : UIGestureRecognizer {
    var myview: UIView
    
    init(target: AnyObject, action: Selector, parentView: UIView) {
        self.myview = parentView
        super.init(target: target, action: action)
    }
    func touchesBegan(touches:NSSet, withEvent:UIEvent) {
        println("otuches begin")
        self.myview.alpha = 0.5

    }
    
    func touchesMoved(touches:NSSet, withEvent: UIEvent) {
                println("otuches moved")
    }
    
    func touchesEnded(touches:NSSet, withEvent: UIEvent) {
        println("otuches ended")
        self.myview.alpha = 1.0
    }
}