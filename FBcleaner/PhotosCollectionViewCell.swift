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
    var keep = false   
    @IBOutlet weak var checkedImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!

    func setThumbnail(image: UIImage){
        self.photoImageView.image = image
    }
    
    func updateCheckmarkPicture(){
        println("updateCheckmarkPicture")
        
        if(self.keep){
            self.keep = false
            var img = UIImageView(image: UIImage(named:"checked"))
            self.checkedImageView = img
        }
        else {
            self.keep = true
            checkedImageView.image = UIImage(named:"unchecked")
            self.setNeedsDisplay()
        }
    }
    

}