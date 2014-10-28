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
        assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);

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
        
        
        self.imageManager.requestImageForAsset(images[indexPath.item], targetSize: cell.targetSize, contentMode:PHImageContentMode.AspectFill, options: initialRequestOptions) { image, info in
            cell.photoImageView.image = image;
        }
        return cell
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