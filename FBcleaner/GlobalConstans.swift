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
    var color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
    return color
}

let DATE_STRING = "dateSinceLastRun"
let BLUE_COLOR = UIColor(red: 38, green: 100, blue: 255, alpha: 100)
let GREEN_COLOR = UIColor(red: 83/255, green: 153/255, blue: 93/255, alpha: 1.0)
let RED_COLOR = UIColor(red: 224, green: 0.3, blue:0.2, alpha: 1.0)
let ANIMATION_TIME = 0.3
let BACKGROUND_COLOR = UIColor(red: 263/255, green: 245/255, blue: 230/255, alpha: 1.0)
let IMAGE_LAYER_COLOR = UIColor.lightGrayColor()