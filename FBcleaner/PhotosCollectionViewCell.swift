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
    @IBOutlet weak var checkedImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!

    func setThumbnail(image: UIImage){
        self.photoImageView.image = image
    }
}