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
            let initialRequestOptions = PHImageRequestOptions()
            initialRequestOptions.networkAccessAllowed = true
            initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat

            self.imageManager?.requestImageForAsset(imageAsset!, targetSize: CGSize(width: 620, height: 620), contentMode: .AspectFit, options: initialRequestOptions) { image, info in
                self.photoImageView.image = image
            }
        }
    }
    
    var imageManager: PHImageManager?
    @IBOutlet weak var photoImageView: UIImageView!
}