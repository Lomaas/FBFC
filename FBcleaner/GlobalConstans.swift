//
//  GlobalConstans.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 02/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit

// colorize function takes HEX and Alpha converts then returns aUIColor object
func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
    let blue = CGFloat((hex & 0xFF)) / 255.0
    let color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
    return color
}

let DATE_STRING = "dateSinceLastRun"
let GREEN_COLOR = UIColor(red: 112/255, green: 196/255, blue: 146/255, alpha: 1.0)
let GREEN_COLOR_DARK = UIColor(red: 105/255, green: 153/255, blue: 93/255, alpha: 1.0)

let RED_DIVERSE_COLOR = UIColor(red: 236/255, green: 112/255, blue:89/255, alpha: 1.0)

let ANIMATION_TIME = 0.3
//let BACKGROUND_COLOR = UIColor(red: 263/255, green: 245/255, blue: 230/255, alpha: 1.0)
let BACKGROUND_COLOR = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)

let IMAGE_LAYER_COLOR = UIColor.lightGrayColor()

// UserDefaults
let PREVIOUS_BUILD_THAT_WAS_RATED = "previousBuildThatWasRated"

let IPHONE_4AND4s = 480
let IPHONE_5AND5s = 568
let IPHONE_6 = 667
let IPHONE_6_PLUS = 736
let IPAD_RETINA = 2048

// TRACKING
let START_VIEW_CONTROLLER = "StartViewController"
let SWIPE_VIEW_CONTROLLER = "SwipeViewController"
let GRID_VIEW_CONTROLLER = "GridViewController"
