//
//  UIDraggableView.swift
//  Friends List Cleaner
//
//  Created by Simen Johannessen on 15/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit
import Photos

func d2r(degrees : Double) -> Double {
    return degrees * M_PI / 180.0
}

protocol DraggableDelegate {
    func didDropOnKeep(_: UIDraggableView)
    func didDropOnTrash(_: UIDraggableView)
    func isBeingDragged(_: UIDraggableView)
    func isBeingTapped(_: UIImageView)
}

class UIDraggableView : UIView {
    let openCenterRight: CGPoint
    let openCenterLeft: CGPoint
    let imageAsset: PHAsset
    var originalCenter: CGPoint
    var lastLocation: CGPoint
    var isDragging: Bool = false
    var diffX: Double
    var diffY: Double
    var leftImage: UIButton
    var rightImage: UIButton
    var backgroundImage: UIImageView
    var dateLabel: UILabel
    var delegate:DraggableDelegate?

    init(frame:CGRect, openCenterRight: CGPoint, openCenterLeft: CGPoint, backgroundImage: UIImageView,
        imageAsset: PHAsset,
        originalCenter: CGPoint) {
        self.openCenterRight = openCenterRight
        self.openCenterLeft = openCenterLeft
        self.originalCenter = originalCenter
        self.diffX = 0.0
        self.diffY = 0.0
        self.lastLocation = CGPointMake(0,0)
        let width: CGFloat = 130
        let height: CGFloat = 65
        let adjustmentWidth: CGFloat = 15
        let adjustmentHeight: CGFloat = 35

        self.leftImage = UIButton(frame: CGRectMake(adjustmentWidth, adjustmentHeight, width, height))
        self.leftImage.setTitle("KEEP", forState: UIControlState.Normal)
        self.leftImage.transform = CGAffineTransformMakeRotation(-0.2)
        self.leftImage.alpha = 0
        self.leftImage.layer.borderColor = GREEN_COLOR_DARK.CGColor
        self.leftImage.setTitleColor(GREEN_COLOR_DARK, forState: UIControlState.Normal)
        self.leftImage.layer.borderWidth = 4.0
        self.leftImage.titleLabel?.font = UIFont.systemFontOfSize(40)
        self.leftImage.layer.cornerRadius = 6.0

        self.rightImage = UIButton(frame: CGRectMake(frame.width - width - adjustmentWidth - 8, adjustmentHeight, width + 20, height))
        self.rightImage.setTitle("TRASH", forState: UIControlState.Normal)
        self.rightImage.setTitleColor(RED_DIVERSE_COLOR, forState: UIControlState.Normal)
        self.rightImage.transform = CGAffineTransformMakeRotation(0.2)
        self.rightImage.alpha = 0
        self.rightImage.layer.borderColor = RED_DIVERSE_COLOR.CGColor
        self.rightImage.layer.borderWidth = 4.0
        self.rightImage.titleLabel?.font = UIFont.systemFontOfSize(40)
        self.rightImage.layer.cornerRadius = 6.0
        
        self.imageAsset = imageAsset
        self.backgroundImage = backgroundImage
        self.dateLabel = UILabel()
        super.init(frame:  frame)
        
        self.backgroundColor = UIColor.blackColor()
        backgroundImage.frame = CGRectMake(0, 0, frame.width, frame.height - 20)
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImage.clipsToBounds = true

        self.addSubview(backgroundImage)
        self.addSubview(self.leftImage)
        self.addSubview(self.rightImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError( "NSCoding not supported")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let touch = touches.first!
        self.lastLocation  = touch.locationInView(self)
    }
    
    
    override func touchesMoved(touches:  Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)

        let touch = touches.first!
        let touchLocation = touch.locationInView(self)
        
        var frame = self.frame
        frame.origin.x = frame.origin.x + touchLocation.x - self.lastLocation.x
        frame.origin.y = frame.origin.y + touchLocation.y - self.lastLocation.y
        self.frame = frame
        
        let alphaPictureLeft = (self.center.x - self.originalCenter.x) / 100
        let alphaPictureRight = (self.originalCenter.x - self.center.x)  / 100
        
        self.leftImage.alpha = alphaPictureLeft
        self.rightImage.alpha =  alphaPictureRight
        self.delegate?.isBeingDragged(self)
        self.isDragging = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.isDragging == false) {
            self.delegate?.isBeingTapped(self.backgroundImage)
        }
        else {
            let touch = touches.first
            let touchLocation = self.center

            if (touchLocation.x >= self.openCenterRight.x) {
                self.delegate?.didDropOnKeep(self)
            }
            else if (touchLocation.x <= self.openCenterLeft.x) {
                self.delegate?.didDropOnTrash(self)
            }
            else {
                self.animateBackToStartPosition()
            }
        }
        self.isDragging = false
    }
    
    func animateBackToStartPosition() {
        UIView.animateWithDuration(0.25,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.center = self.originalCenter
                self.alpha = 1.0
                self.leftImage.alpha = 0
                self.rightImage.alpha = 0
            },
            completion: nil)
    }
}