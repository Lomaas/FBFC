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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
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
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.setViewToNotLoading()
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        println(formatter.stringFromDate(date))
        Date().setDate(formatter.stringFromDate(date))
    }
    
    func goToStartViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("StartViewController") as UIViewController;
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func cancelCalled(sender: AnyObject) {
        self.goToStartViewController()
    }

    @IBAction func deleteImages(sender: AnyObject) {
        var temp: [PHAsset] = self.getAssetsToBeDeleted()
        
        if(temp.count == 0){
            let alertController = UIAlertController(title: "No picture selected", message:
                "Select some images by tapping on the picture", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        self.setViewToLoading()
        let gridView: GridViewController = self
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.deleteAssets(temp)
            }, completionHandler: { noError, error in
                NSLog("Changes complete. Did they succeed? Who knows! \(noError)")

                if(noError == true){
                    // Go to success view
                    self.goToStartViewController()
                }
                else if(noError == false){
                    // User pressed false
                    println("What is the error? \(error.localizedDescription)")
                    gridView.setViewToNotLoading()
                }
                else {
                    let alertController = UIAlertController(title: "Ups", message:
                        "We are sorry. Something went wrong while deleting your pictures. Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                        self.setViewToNotLoading()
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        })
    }
    
    func setViewToNotLoading(){
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.uiCollectionView.alpha = 1
    }
    
    func setViewToLoading(){
        self.activityIndicator.hidden = false
        self.uiCollectionView.alpha = 0.4
        self.activityIndicator.startAnimating()
        
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
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
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