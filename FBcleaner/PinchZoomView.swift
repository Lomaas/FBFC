//
//  PinchZoomView.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 10/11/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit

protocol PinchZoomDelegate {
    func setNavigationBarVisible()
}

class PinchZoomView: UIView, UIScrollViewDelegate {
    var scrollView: UIScrollView
    var uiImageView: UIImageView
    var delegate: PinchZoomDelegate?
    
    init(imageView: UIImageView, frame: CGRect){
        self.uiImageView = UIImageView(frame: frame)
        self.uiImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.uiImageView.image = imageView.image
        self.uiImageView.layer.backgroundColor = UIColor.blackColor().CGColor
        
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView.scrollsToTop = false
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 6.5;
        self.scrollView.contentSize = frame.size
        
        super.init(frame: frame)
        
        self.scrollView.delegate = self;
        self.scrollView.addSubview(self.uiImageView)
        self.addSubview(self.scrollView)

        let test = UITapGestureRecognizer(target: self, action: "singleTapButton:")
        test.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(test)

        let singleTap = UITapGestureRecognizer(target: self, action: "singleTapButton:")
        singleTap.numberOfTapsRequired = 1
        var button = UIButton(frame: CGRectMake(3, 19, 60, 30))
        button.setTitle("back", forState: UIControlState.Normal)
        button.addGestureRecognizer(singleTap)
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 3.0
        self.addSubview(button)
        self.backgroundColor = UIColor.blackColor()
        centerScrollViewContents()

    }
    
    func updateFrame(){
        self.uiImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.scrollView.scrollsToTop = false
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 6.5;
        self.scrollView.contentSize = frame.size
        centerScrollViewContents()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implementeed")
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.uiImageView
    }
    
    func singleTapButton(recognizer: UITapGestureRecognizer){
        self.animateAndRemoveView();
    }
    
    func animateAndRemoveView(){
        UIView.animateWithDuration(0.2, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
            animations:{
                self.transform = CGAffineTransformMakeScale(0.95, 0.8);
            },
            completion: { finished in
                self.removeFromSuperview()
                self.delegate?.setNavigationBarVisible()
            }
        );
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