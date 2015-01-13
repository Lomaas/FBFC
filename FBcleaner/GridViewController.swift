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


protocol GoBackDelegate {
    func dissmissMyViewController(view: UIViewController, toStartView: Bool, animated: Bool, title: String, msg: String)
}

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var images: [PHAsset] = []
    var imagesToDelete = []
    let rateAppService: RateAppService
    var viewLoading: UIView
    var hasDeleted = false
    var deleteCounter: Int = 0
    let imageManager = PHCachingImageManager()
    var imagesArray: [Bool] = []
    let initialRequestOptions = PHImageRequestOptions()
    var imageCacheController: ImageCacheController!
    var assetGridThumbnailSize: CGSize!
    var delegate: GoBackDelegate?
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    required init(coder aDecoder: NSCoder) {
        initialRequestOptions.networkAccessAllowed = true
        initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        var scale = UIScreen.mainScreen().scale
        var cellSize = CGSizeMake(100,100)
        assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
        self.viewLoading = UIView()
        self.rateAppService = RateAppService()
        super.init(coder: aDecoder)
    }
    
    func updateDeleteLabel(){
        if(self.deleteCounter > 0){
            self.deleteButton.title = "Delete (\(self.deleteCounter))"
        }
        else {
            self.deleteButton.title = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCacheController = ImageCacheController(imageManager: self.imageManager, images: self.images, preheatSize: 1)
        imageCacheController.targetSize = assetGridThumbnailSize
        self.imagesToDelete = self.images
        self.deleteCounter = self.imagesToDelete.count
        self.updateDeleteLabel();
        self.deleteButton.tintColor = RED_DIVERSE_COLOR
        self.view.backgroundColor = nil
        self.uiCollectionView.backgroundColor = nil
        self.uiCollectionView.delegate = self
        self.uiCollectionView.dataSource = self

        for x in images {
            self.imagesArray.append(false)
        }
        
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        println(formatter.stringFromDate(date))
        Date().setDate(formatter.stringFromDate(date))
        self.setViewToNotLoading()
    }
    
    func goToStartViewController(){
        self.delegate?.dissmissMyViewController(self as UIViewController, toStartView: true, animated: false, title: "Success", msg:"Your pictures were deleted")
    }
    
    @IBAction func cancelCalled(sender: AnyObject) {
        println("Cancel")
        self.delegate?.dissmissMyViewController(self as UIViewController, toStartView: false, animated: true, title: "", msg: "")
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
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.deleteAssets(temp)
            }, completionHandler: self.completionHandler)
    }
    
    func completionHandler (noError: Bool, error: NSError?) {
        NSLog("Changes complete. Did they succeed? Who knows! \(noError), \(error?.localizedDescription)")
        self.viewLoading.removeFromSuperview()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.cancelButton.enabled = true
        self.deleteButton.enabled = true
        CATransaction.flush()
        
        if error == nil {
            self.hasDeleted = true
            if (self.rateAppService.isNewVersion()) {
                rateUsOnAppStore()
            } else {
                self.succesFullDeletionDontRate()
            }
        }
    }
    
    func succesFullDeletionDontRate() {
        let alertController = UIAlertController(title: "Success!", message: "Your photos were successfully deleted", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Back to start", style: UIAlertActionStyle.Default, { (UIAlertAction) -> Void in
            self.goToStartViewController()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func rateUsOnAppStore() {
        let alertController = UIAlertController(title: "Success! Rate us on app store", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Sure", style: UIAlertActionStyle.Default, handler: {
            void in
            println("Hiiya")
            self.rateAppService.setNewPreviousBuildThatWasRated()
            self.goToStartViewController()
            UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=940183182&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
        }))
        
        alertController.addAction(UIAlertAction(title: "Later. I'll go back to start", style: UIAlertActionStyle.Default, { (UIAlertAction) -> Void in
                self.goToStartViewController()
        }))
                
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func setViewToNotLoading(){
        self.viewLoading.removeFromSuperview()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.cancelButton.enabled = true
        self.deleteButton.enabled = true
        CATransaction.flush()
    }
    
    func setViewToLoading(){
        self.viewLoading = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        var indicatior = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2 - 50, self.view.frame.height/2 - 50, 100, 100))
        indicatior.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicatior.startAnimating()
        indicatior.color = UIColor.whiteColor()
        self.viewLoading.alpha = 0.7
        self.viewLoading.addSubview(indicatior)
        self.viewLoading.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.viewLoading)
        self.cancelButton.enabled = false
        self.deleteButton.enabled = false
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
        if(self.hasDeleted == true){
            return 0
        }
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
            cell.photoImageView.image = image?;
        }
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.transform = CGAffineTransformMakeRotation(0.1);
        
        self.imagesArray[indexPath.item] = !self.imagesArray[indexPath.item]
        
        if(self.imagesArray[indexPath.item] == true){
            self.deleteCounter -= 1
            cell.checkedImageView.image = UIImage(named:"unchecked")
        }
        else {
            self.deleteCounter += 1
            cell.checkedImageView.image = UIImage(named:"checked")
        }
        self.updateDeleteLabel()
        self.uiCollectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexPaths = self.uiCollectionView.indexPathsForVisibleItems()
        imageCacheController.updateVisibleCells(indexPaths as [NSIndexPath])
    }
}