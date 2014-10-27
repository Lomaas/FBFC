//
//  PhotosCollectionViewCell.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 27/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotosCollectionViewCell: UICollectionViewCell {
    
    var imageAsset: PHAsset? {
        didSet {
            self.imageManager?.requestImageForAsset(imageAsset!, targetSize: CGSize(width: 320, height: 320), contentMode: .AspectFill, options: nil) { image, info in
                self.photoImageView.image = image
            }
            starButton.alpha = imageAsset!.favorite ? 1.0 : 0.4
        }
    }
    
    var imageManager: PHImageManager?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    
    @IBAction func handleStarButtonPressed(sender: AnyObject) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let changeRequest = PHAssetChangeRequest(forAsset: self.imageAsset)
            changeRequest.favorite = !self.imageAsset!.favorite
            }, completionHandler: nil)
    } 
}