//
//  PinchZoomView.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 10/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit

class PinchZoomView: UIView, UIScrollViewDelegate {
    var scrollView: UIScrollView
    var uiImageView: UIImageView
    
    init(imageView: UIImageView, frame: CGRect){
        self.uiImageView = UIImageView(frame: frame)
        self.uiImageView.image = imageView.image
        self.uiImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 6.5;
        self.scrollView.contentSize = frame.size
        super.init(frame: frame)
        self.scrollView.delegate = self;
        self.scrollView.addSubview(self.uiImageView)
        self.addSubview(self.scrollView)
        
        var doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTap)
        
        var singleTap = UITapGestureRecognizer(target: self, action: "singleTapButton:")
        singleTap.numberOfTapsRequired = 1
        self.uiImageView.addGestureRecognizer(singleTap)

        var button = UIButton(frame: CGRectMake(3, 19, 60, 30))
        button.setTitle("back", forState: UIControlState.Normal)
        button.addGestureRecognizer(singleTap)
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 3.0
        self.addSubview(button)
        
        centerScrollViewContents()

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("not implementeed")
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.uiImageView
    }
    
    func singleTapButton(recognizer: UITapGestureRecognizer){
        self.removeFromSuperview()
    }

    func handleDoubleTap(recognizer: UITapGestureRecognizer){
        let pointInView = recognizer.locationInView(self.uiImageView)
        
        var newZoomScale = self.scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, self.scrollView.maximumZoomScale)
        
        let scrollViewSize = self.scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func centerScrollViewContents() {
        let boundsSize = self.scrollView.bounds.size
        var contentsFrame = self.uiImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        self.uiImageView.frame = contentsFrame
    }
}