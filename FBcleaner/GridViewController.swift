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

class GridViewController: UICollectionViewController, PHPhotoLibraryChangeObserver {
    
    var images: PHFetchResult! = nil
    let imageManager = PHCachingImageManager()
    var imageCacheController: ImageCacheController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        imageCacheController = ImageCacheController(imageManager: imageManager, images: images, preheatSize: 1)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        
        // Configure the cell
        cell.imageManager = imageManager
        cell.imageAsset = images[indexPath.item] as? PHAsset
        
        return cell
    }
    
    // MARK: - ScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPaths = collectionView.indexPathsForVisibleItems()
        imageCacheController.updateVisibleCells(indexPaths as [NSIndexPath])
    }
    
    // MARK: - PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange!) {
        let changeDetails = changeInstance.changeDetailsForFetchResult(images)
        
        self.images = changeDetails.fetchResultAfterChanges
        dispatch_async(dispatch_get_main_queue()) {
            // Loop through the visible cell indices
            let indexPaths = self.collectionView.indexPathsForVisibleItems()
            for indexPath in indexPaths as [NSIndexPath] {
                if changeDetails.changedIndexes.containsIndex(indexPath.item) {
                    let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as PhotosCollectionViewCell
                    cell.imageAsset = changeDetails.fetchResultAfterChanges[indexPath.item] as? PHAsset
                }
            }
        }
    }
}