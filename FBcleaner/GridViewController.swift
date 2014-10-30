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

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var images: [PHAsset] = []
    var imagesToDelete = []
    let imageManager = PHCachingImageManager()
    var imagesArray: [Bool] = []
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
        self.view.backgroundColor = nil
        self.uiCollectionView.backgroundColor = nil
        var scale = UIScreen.mainScreen().scale
        var cellSize = CGSizeMake(100,100)
        imagesToDelete = images
        assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)

        imageCacheController = ImageCacheController(imageManager: imageManager, images: images, preheatSize: 1)
        imageCacheController.targetSize = assetGridThumbnailSize
        
        for x in images {
            self.imagesArray.append(false)
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    
    @IBAction func deleteImages(sender: AnyObject) {
        var temp: [PHAsset] = self.getAssetsToBeDeleted()
        
        if(temp.count == 0){
            let alertController = UIAlertController(title: "No images selected", message:
                "Hello, world!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Select some images by tapping on the picture", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.deleteAssets(temp)
            }, completionHandler:nil)
    }
    
    func getAssetsToBeDeleted() -> [PHAsset] {
        var counter = 0
        var temp: [PHAsset] = []
        
        for x in self.imagesArray {
            if(x == false){
                temp.append(images[counter])
            }
            counter += 1
        }
        return temp
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        
        if(self.imagesArray[indexPath.item] == true){
            cell.checkedImageView.image = UIImage(named:"unchecked")
        }
        else {
            cell.checkedImageView.image = UIImage(named:"checked")
        }
        self.imageManager.requestImageForAsset(images[indexPath.item], targetSize: assetGridThumbnailSize, contentMode:PHImageContentMode.AspectFill, options: initialRequestOptions) { image, info in
            cell.photoImageView.image = image;
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("didSelectItemAtIndexPath")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        println("updateCheckmarkPicture")
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.transform = CGAffineTransformMakeRotation(0.1);
        
        self.imagesArray[indexPath.item] = !self.imagesArray[indexPath.item]
        
        if(self.imagesArray[indexPath.item] == true){
            cell.checkedImageView.image = UIImage(named:"unchecked")
        }
        else {
            cell.checkedImageView.image = UIImage(named:"checked")
        }
        self.uiCollectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPaths = self.uiCollectionView.indexPathsForVisibleItems()
        imageCacheController.updateVisibleCells(indexPaths as [NSIndexPath])
    }
}