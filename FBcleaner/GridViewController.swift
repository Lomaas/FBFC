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

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var images: [PHAsset] = []
    var imagesToDelete = []
    let imageManager = PHCachingImageManager()
    let initialRequestOptions = PHImageRequestOptions()
    var imageCacheController: ImageCacheController!
    var assetGridThumbnailSize: CGSize!
    @IBOutlet weak var uiCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCollectionView.delegate = self
        self.uiCollectionView.dataSource = self
        initialRequestOptions.networkAccessAllowed = true
        initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        
        var scale = UIScreen.mainScreen().scale
        var cellSize = CGSizeMake(80,80)
        imagesToDelete = images
        assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)

        imageCacheController = ImageCacheController(imageManager: imageManager, images: images, preheatSize: 1)
        imageCacheController.targetSize = assetGridThumbnailSize
    }
    
    // MARK: UICollectionViewDataSource
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        
        // Configure the cell
        cell.imageManager = imageManager
//        cell.imageAsset = images[indexPath.item]
        cell.targetSize = assetGridThumbnailSize
        
        if(cell.keep){
            cell.checkedImageView.image = UIImage(named: "unchecked")
        }
        else {
            cell.checkedImageView.image = UIImage(named: "checked")
        }
        
        self.imageManager.requestImageForAsset(images[indexPath.item], targetSize: cell.targetSize, contentMode:PHImageContentMode.AspectFill, options: initialRequestOptions) { image, info in
            cell.photoImageView.image = image;
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("didSelectItemAtIndexPath")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        cell.updateCheckmarkPicture()
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
               let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        cell.backgroundColor = UIColor.blueColor()
        cell.alpha = 0.5
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        cell.backgroundColor = nil
        cell.alpha = 1
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPaths = self.uiCollectionView.indexPathsForVisibleItems()
        imageCacheController.updateVisibleCells(indexPaths as [NSIndexPath])
    }
    
    @IBAction func confirmDelete(sender: AnyObject) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.deleteAssets(self.images)
            }, completionHandler:nil)
    }
}