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
    var imageManager: PHImageManager?
    var targetSize: CGSize!
   
    @IBOutlet weak var photoImageView: UIImageView!
    //    var imageAsset: PHAsset? {
//        didSet {
//            
//            var scale = UIScreen.mainScreen().scale
//            var cellSize = CGSizeMake(80,80)
//            targetSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
//            
//            let initialRequestOptions = PHImageRequestOptions()
//            initialRequestOptions.networkAccessAllowed = true
//            initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
//
//            self.imageManager?.requestImageForAsset(imageAsset!, targetSize: targetSize!, contentMode: .AspectFill, options: initialRequestOptions) { image, info in
//                self.photoImageView.image = image
//            }
//        }
//    }
//    
    func setThumbnail(image: UIImage){
        self.photoImageView.image = image
    }
    

}