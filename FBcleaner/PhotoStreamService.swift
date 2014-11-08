////
////  UIDraggableService.swift
////  FBcleaner
////
////  Created by Simen Johannessen on 07/11/14.
////  Copyright (c) 2014 Simen Johannessen. All rights reserved.
////
//
//import Foundation
//
////
////  ViewController.swift
////  Friends List Cleaner
////
////  Created by Simen Johannessen on 15/10/14.
////  Copyright (c) 2014 Simen Johannessen. All rights reserved.
////
//
//import UIKit
//import Photos
//
//class PhotoQueue {
//    var queue: [UIDraggableView] = []
//    var motherView: UIViewController
//    
//    init(assets: [PHAsset], motherView: UIViewController) {
//        self.assetsLeftToEvaluate = assets
//        self.motherView = motherView
//        
//        for asset in assets {
//            self.fetchImage(asset)
//        }
//    }
//    
//    func keepButtonPressed(draggable: UIDraggableView) {
//        println("keep button pressed")
//        self.keepImage(draggable)
//    }
//    
//    func trashButtonPressd(draggable: UIDraggableView) {
//        self.dropImage(draggable)
//    }
//    
//    func fetchImage(asset: PHAsset){
//        let initialRequestOptions = PHImageRequestOptions()
//        initialRequestOptions.networkAccessAllowed = true
//        initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
//        
//        self.imageManager.requestImageForAsset(asset,
//            targetSize: CGSize(width: 650, height: 650),
//            contentMode:PHImageContentMode.AspectFit, options: initialRequestOptions) { (result, _) in
//                if let res: UIImage = result {
//                    self.createUiDraggableView(result, imageAsset: asset)
//                }
//        }
//    }
//
//    
//    func handleDoubleTap(recognizer : UIPinchGestureRecognizer){
//        println("DoubbleTap")
//        if(self.assetsLeftToEvaluate.count < 2){
//            // Update UI LABEL WITH INFO THAT IT ISNT ALLOWED
//            return
//        }
//        let imageView = UIImageView(image: UIImage(named: "checked"))
//        
//        if let tappedView: UIDraggableView = recognizer.view? as? UIDraggableView {
//            
//            //            imageView.frame = CGRectMake(0, 0, 50, 50)
//            //            imageView.contentMode = UIViewContentMode.ScaleAspectFit
//            //            imageView.center = tappedView.originalCenter
//            //            tappedView.addSubview(imageView)
//            UIView.animateWithDuration(0.35,
//                delay: 0,
//                options: UIViewAnimationOptions.CurveLinear,
//                animations: {
//                    tappedView.center = CGPointMake(self.motherView.view.frame.width/2, -150)
//                    tappedView.alpha = 0.2
//                },
//                completion: { finished in
//                    tappedView.center = tappedView.originalCenter
//                    tappedView.alpha = 1
//                    
//                    var asset: PHAsset = self.assetsLeftToEvaluate.last as PHAsset!
//                    self.assetsLeftToEvaluate.removeLast()
//                    self.assetsLeftToEvaluate.insert(asset, atIndex: 0)
//            })
//        }
//    }
//    
//    func isBeingDragged(view: UIDraggableView) {
//
//    }
//    
//    func didDropOnKeep(view: UIDraggableView){
//        println("didDropOnKeep")
//        self.keepImage(view)
//    }
//    
//    func didDropOnTrash(view: UIDraggableView){
//        println("didDropOnTrash")
//        self.dropImage(view)
//    }
//    
//    func keepImage(view: UIDraggableView){
//        self.assetsLeftToEvaluate.removeLast()
//        self.uiDraggablesArray.removeLast()
//        
//        if(self.assetsLeftToEvaluate.count == 0){
//            self.deleteImages()
//        }
//    }
//    
//    func dropImage(view: UIDraggableView){
//        self.assetsLeftToEvaluate.removeLast()
//        self.uiDraggablesArray.removeLast()
//        self.assetsToDelete.append(view.imageAsset)
//        
//        if(self.assetsLeftToEvaluate.count == 0){
//            self.deleteImages()
//        }
//    }
//    
//    func evaluateLater(){
//        
//    }
//    
//    
//    func deleteImages(){
//        if(self.assetsToDelete.count == 0){
//            let alertController = UIAlertController(title: "Nothing trashed", message:
//                "You have decided to keep all your pictures", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "Back to start", style: UIAlertActionStyle.Default, handler: { action in
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }))
//            self.presentViewController(alertController, animated: true, completion: nil)
//            return
//        }
//        self.motherView.view.goToGridView()
//    }
//}
//
