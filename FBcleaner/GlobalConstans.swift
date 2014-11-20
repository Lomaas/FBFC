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
let GREEN_COLOR = UIColor(red: 0, green: 200, blue: 0, alpha: 0.5)
let RED_COLOR = UIColor(red: CGFloat(224), green: CGFloat(0), blue: CGFloat(0), alpha: 1.0)
let ANIMATION_TIME = 0.3