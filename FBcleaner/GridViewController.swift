//
//  GridViewController.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 27/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"

class GridViewController: UICollectionViewController {
    
    var images: [PHAsset] = []
    let imageManager = PHCachingImageManager()
    var imageCacheController: ImageCacheController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.images.count == 0){
            
        }
        imageCacheController = ImageCacheController(imageManager: imageManager, images: images, preheatSize: 1)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if(self.images.count > 1){
            return 2
        }
        else {
            return 1
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        
        // Configure the cell
        cell.imageManager = imageManager
        cell.imageAsset = images[indexPath.item]
        
        return cell
    }
    
    // MARK: - ScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPaths = collectionView.indexPathsForVisibleItems()
        imageCacheController.updateVisibleCells(indexPaths as [NSIndexPath])
    }
}