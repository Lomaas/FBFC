//
//  ViewController.swift
//  Friends List Cleaner
//
//  Created by Simen Johannessen on 15/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import UIKit
import Photos

class ViewController: GAITrackedViewController, DraggableDelegate, GoBackDelegate, PinchZoomDelegate {
    let imageManager = PHCachingImageManager()
    var assetsToDelete: [PHAsset] = []
    var uiDraggablesArray: [UIDraggableView] = []
    var assetsLeftToEvaluate: [PHAsset]
    var tmpAssets: [PHAsset]
    var sizeTrashedFloat: Float
    var imagesLoaded: Int
    var imagesLeftToEval: Int
    var animateStack: Bool
    var originalFrame: CGRect
    var sizeTrashed: UILabel
    var delegate: GoBackDelegate?

    @IBOutlet weak var leftActionBarButton: UIBarButtonItem!
    @IBOutlet weak var keepButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addSubView: UIButton!
    @IBOutlet weak var mainbackground: UIImageView!
    @IBOutlet weak var skipRestButton: UIBarButtonItem!
    @IBOutlet weak var titleNavBar: UINavigationItem!
    @IBOutlet weak var containerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        self.assetsLeftToEvaluate = []
        self.tmpAssets = []
        self.imagesLoaded = 0
        self.imagesLeftToEval = 0
        self.sizeTrashedFloat = 0.0
        self.animateStack = true
        self.originalFrame = CGRectMake(0, 0, 0, 0)
        self.sizeTrashed = UILabel(frame: CGRectMake(0, 0, 140, 25))
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = SWIPE_VIEW_CONTROLLER
        self.containerView.backgroundColor = BACKGROUND_COLOR
        self.sizeTrashed.textColor = RED_DIVERSE_COLOR
        self.skipRestButton.tintColor = RED_DIVERSE_COLOR
        self.keepButton.backgroundColor = GREEN_COLOR_DARK
        self.keepButton.tintColor = RED_DIVERSE_COLOR
        self.trashButton.backgroundColor = RED_DIVERSE_COLOR
        self.sizeTrashed.backgroundColor = RED_DIVERSE_COLOR
        self.sizeTrashed.layer.cornerRadius = 3.0
        self.sizeTrashed.textColor = UIColor.whiteColor()
        self.sizeTrashed.clipsToBounds = true
        self.sizeTrashed.textAlignment = NSTextAlignment.Center
        self.sizeTrashed.text = "0.0 MB in trash"
        self.titleNavBar.titleView = self.sizeTrashed

        self.view.backgroundColor = BACKGROUND_COLOR
        let screenRect = UIScreen.mainScreen().bounds
        let screenHeight = screenRect.size.height
        var adjustment = CGFloat(10)

        if (screenHeight >= CGFloat(IPHONE_5AND5s)) {
            adjustment = CGFloat(45)
        }
        
        if (screenHeight >= CGFloat(IPHONE_6)) {
            adjustment = CGFloat(100)
        }
        
        if (screenHeight >= CGFloat(IPHONE_6_PLUS)) {
            adjustment = CGFloat(130)
        }
        
        if (screenHeight >= CGFloat(IPAD_RETINA)) {
            adjustment = CGFloat(250)
        }
        
        let width = self.view.frame.width - 20
        let height = (screenHeight/2) + adjustment
        
        print("Height: \(height), screenheight: \(screenHeight)")
        
        self.originalFrame = CGRectMake(10, 12, width, height)
        let initPictures = 3
        
        for (var i=0; i < initPictures && i < self.tmpAssets.count; i++) {
            self.fetchImage(self.tmpAssets[i], index: i, successHandler: { (res, asset) -> Void in
                let uiDraggable = self.createUiDraggableView(res, imageAsset: asset, imageNumber: self.imagesLoaded + 1)
                self.imagesLoaded += 1
                self.updateQueuePointers(asset, uiDragable: uiDraggable)
                self.view.insertSubview(uiDraggable, aboveSubview: self.containerView)
                self.updateUserInteraction();
            },
            errorHandler: { (asset, index) -> Void in
                if (self.tmpAssets.count == 1 || index == self.tmpAssets.count - 1 ) {
                    let alertController = UIAlertController(title: "No pictures found", message:
                        "Only photos currently not supported were found. Please try another date to try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Back to start", style: UIAlertActionStyle.Default, handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }

                if self.imagesLoaded > 0 {
                    self.imagesLoaded -= 1
                }
                self.tmpAssets.removeAtIndex(index)
                self.fetchNextAsset(true, jumpIndex: initPictures - 1)
                
                if self.imagesLeftToEval > 0 {
                    self.imagesLeftToEval -= 1
                }
            })
        }
    }
    
    
    @IBAction func undoPressed(sender: AnyObject) {
        if self.imagesLeftToEval == 0 {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            // Load previous Picture
            let trackDictionary = GAIDictionaryBuilder.createEventWithCategory("button_pressed", action: "undo pressed", label: "", value: nil).build()
            GAI.sharedInstance().defaultTracker.send(trackDictionary as [NSObject : AnyObject])
            
            self.animateStack = true
            if self.uiDraggablesArray.count > 2 {
                self.removeLastPictureInQueue()
            }
            self.removedPictureFromQueueUpateCounters()
            self.addPreviousReviewedPicture()
        }
    }
    
    @IBAction func keepButtonPressed(sender: AnyObject) {
        self.animateStack = false
        let draggable:UIDraggableView = self.uiDraggablesArray.last as UIDraggableView!
        self.keepImage(draggable)
        
        UIView.animateWithDuration(0.15,
            delay:0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                draggable.leftImage.alpha = 1
            },
            completion: { finished in
                UIView.animateWithDuration(ANIMATION_TIME,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: {
                        draggable.center = CGPointMake(self.view.frame.width + draggable.frame.width , draggable.center.y)
                        draggable.alpha = 0.9
                        draggable.leftImage.alpha = 1
                        draggable.transform = CGAffineTransformMakeRotation(0.2)
                    },
                    completion: { finished in
                        draggable.removeFromSuperview()

                    }
                )
            }
        )
    }
    
    @IBAction func trashButtonPressed(sender: AnyObject) {
        self.animateStack = false
        let draggable:UIDraggableView = self.uiDraggablesArray.last as UIDraggableView!
        self.dropImage(draggable)
        
        UIView.animateWithDuration(0.15,
            delay:0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                draggable.rightImage.alpha = 1
            },
            completion: { finished in
                UIView.animateWithDuration(ANIMATION_TIME,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: {
                        draggable.center = CGPointMake(-draggable.frame.width, draggable.center.y)
                        draggable.alpha = 0.9
                        draggable.rightImage.alpha = 1
                        draggable.transform = CGAffineTransformMakeRotation(-0.2)
                    },
                    completion: { finished in
                        draggable.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    func fetchImage(asset: PHAsset, index: Int, successHandler: (res: UIImage, asset: PHAsset) -> Void,
        errorHandler: (asset: PHAsset, index: Int) -> Void){
        let initialRequestOptions = PHImageRequestOptions()
        initialRequestOptions.networkAccessAllowed = true
        initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat

        self.imageManager.requestImageForAsset(asset,
            targetSize: CGSize(width: 650, height: 650),
            contentMode:PHImageContentMode.AspectFit, options: initialRequestOptions) { (result, _) in
                if let res: UIImage = result {
                    successHandler(res: res, asset: asset)
                } else {
                    errorHandler(asset: asset, index: index)
                }
        }
    }
   
    func createUiDraggableView(img: UIImage, imageAsset: PHAsset, imageNumber: Int) -> UIDraggableView{
        let image = UIImageView(image: img)
        let rightPointX = self.view.frame.width - 130
        let leftPointX = CGFloat(130.0)
        image.contentMode = UIViewContentMode.ScaleAspectFill
        
        let uiDragable = UIDraggableView(
            frame: self.createFrameForPositionInQueue(self.getPositionInQueue()),
            openCenterRight: CGPointMake(rightPointX, 100),
            openCenterLeft: CGPointMake(leftPointX, 100),
            backgroundImage: image,
            imageAsset: imageAsset,
            originalCenter: CGPoint(
                x: self.originalFrame.origin.x + self.originalFrame.width/2,
                y: self.originalFrame.origin.y + self.originalFrame.height/2
            )
        )
        
        uiDragable.delegate = self
        uiDragable.backgroundColor = UIColor.whiteColor()
        uiDragable.layer.borderColor = IMAGE_LAYER_COLOR.CGColor
        uiDragable.layer.borderWidth = 1
        uiDragable.layer.cornerRadius = 10.0
        uiDragable.clipsToBounds = true
        
        let label = UILabel(frame: CGRectMake(0, uiDragable.frame.height - 23, self.view.frame.width, 20))
        let formatter = self.getImageSize(img)
        
        if let creationDate = imageAsset.creationDate {
            label.text = "\(Date().getDateStringFromNSDate(creationDate)) \(formatter) MB - \(imageNumber)/\(self.tmpAssets.count)"
        }
        label.font = UIFont(name: "System", size: 15)
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        uiDragable.addSubview(label)
        uiDragable.dateLabel = label
        return uiDragable
    }
    
    func getPositionInQueue() -> Int {
        if(self.uiDraggablesArray.count > 2){
            return 2;
        }
        if(self.uiDraggablesArray.count == 2){
            return 1
        }
        if(self.uiDraggablesArray.count == 1){
            return 0
        }
        return 0
    }
    
    func getImageSize(img: UIImage) -> NSString {
        let imgSize  = CGImageGetHeight(img.CGImage) * CGImageGetBytesPerRow(img.CGImage);
        let test = Float(imgSize) / 1000000
        let size = test / 10.0
        return NSString(format: "%.01f", size)
    }

    func didDropOnKeep(view: UIDraggableView) {
        self.animateStack = true
        self.animateUIDraggableOutFromScreen(view, leftImageAlpha: 1.0, rightImageAlpha: 0.0, center: CGPointMake(self.view.frame.width + view.frame.width, view.center.y), rotation: 0.2)
        self.keepImage(view)
    }
    
    func didDropOnTrash(view: UIDraggableView) {
        self.animateStack = true
        self.animateUIDraggableOutFromScreen(view, leftImageAlpha: 0.0, rightImageAlpha: 1.0, center: CGPointMake(-view.frame.width, view.center.y), rotation: -0.2)
        self.dropImage(view)
    }
    
    func keepImage(view: UIDraggableView) {
        self.fetchNextAsset(false, jumpIndex: 0)

        self.assetsLeftToEvaluate.removeLast()
        self.uiDraggablesArray.removeLast()
        self.updateUserInteraction()
        
        if(self.isNoMoreImages() == true){
            self.goToGridView()
        }
    }
    
    func dropImage(view: UIDraggableView){
        self.fetchNextAsset(false, jumpIndex: 0)
        self.incrementSizeOfTrash(view)
        self.assetsLeftToEvaluate.removeLast()
        self.uiDraggablesArray.removeLast()
        
        self.assetsToDelete.append(view.imageAsset)
        self.setDeleteTitleLabel()
        self.updateUserInteraction()

        if(self.isNoMoreImages() == true){
            self.goToGridView()
        }
    }
    
    func isNoMoreImages() -> Bool {
        if(self.assetsLeftToEvaluate.count == 0){
            return true
        }
        else {
            return false
        }
    }
    
    func removeLastPictureInQueue(){
        let view = self.uiDraggablesArray[0]
        view.removeFromSuperview()
        self.assetsLeftToEvaluate.removeAtIndex(0)
        self.uiDraggablesArray.removeAtIndex(0)
    }
    
    func removedPictureFromQueueUpateCounters(){
        self.imagesLoaded -= 1
        self.imagesLeftToEval -= 1
    }
    
    func updateUserInteraction(){
        let padding = CGFloat(6.0)
        
        if(self.uiDraggablesArray.count > 2) {
            self.uiDraggablesArray[2].userInteractionEnabled = true
            self.uiDraggablesArray[1].userInteractionEnabled = false
            self.uiDraggablesArray[0].userInteractionEnabled = false
            self.updateUiDraggableFrame(0, paddingWidth: padding * 2, paddingHeight: padding * 2)
            self.updateUiDraggableFrame(1, paddingWidth: padding, paddingHeight: padding)
            self.updateUiDraggableFrame(2, paddingWidth: 0, paddingHeight: 0)
        }
        else if(self.uiDraggablesArray.count == 2 ) {
            self.uiDraggablesArray[1].userInteractionEnabled = true
            self.uiDraggablesArray[0].userInteractionEnabled = false
            self.updateUiDraggableFrame(0, paddingWidth: padding, paddingHeight: padding)
            self.updateUiDraggableFrame(1, paddingWidth: 0, paddingHeight: 0)
        }

        else if(self.uiDraggablesArray.count == 1) {
            self.uiDraggablesArray[0].userInteractionEnabled = true
            self.updateUiDraggableFrame(0, paddingWidth: 0, paddingHeight: 0)
        }

    }
    
    func createFrameForPositionInQueue(index: Int) -> CGRect {
        let padding = CGFloat(6.0) * CGFloat(2 - index)
        
        let frame = CGRectMake(
            self.originalFrame.origin.x + padding,
            self.originalFrame.origin.y + padding,
            self.originalFrame.width - padding*2,
            self.originalFrame.height)
        return frame
    }
    
    func updateUiDraggableFrame(index: Int, paddingWidth: CGFloat, paddingHeight: CGFloat) {
        let draggable = self.uiDraggablesArray[index] as UIDraggableView
        let frame = self.createFrameForPositionInQueue(index)
        let width = CGFloat(27)
        
        if (self.animateStack) {
            UIView.animateWithDuration(0.15,
                delay:0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    draggable.frame = frame
                    draggable.backgroundImage.frame = CGRectMake(1, 1, frame.width - 2, frame.height - width)
                },
                completion: { finished in
                }
            )
        }
        else {
            draggable.frame = frame
            draggable.backgroundImage.frame = CGRectMake(1, 1, frame.width - 2, frame.height - width)
        }
    }
    
    func getImageNumber() -> Int {
        return self.imagesLeftToEval + 1
    }
    
    func addPreviousReviewedPicture(){
        let asset = getPreviousAssetEvaulated()
        var wasTrashed = false
        if(self.assetsToDelete.count > 0 && self.assetsToDelete.last!.isEqual(asset)){
            wasTrashed = true
        }
        
        self.fetchImage(asset, index: self.imagesLoaded,
            successHandler: { (res, asset) -> Void in

                let uiDraggable = self.createUiDraggableView(res, imageAsset: asset, imageNumber: self.getImageNumber())
                self.assetsLeftToEvaluate.append(asset)
                self.uiDraggablesArray.append(uiDraggable)

                if(wasTrashed){
                    self.assetsToDelete.removeLast()
                    self.addUIDraggableFromLeft(uiDraggable)
                    self.decrementSizeOfTrash(uiDraggable)
                }
                else {
                    self.addUIDraggableFromRight(uiDraggable)
                }
                self.setDeleteTitleLabel()
                self.updateUserInteraction()
                
                if(self.imagesLeftToEval == 0){
                    self.leftActionBarButton.title = "Back"
                }
            },
            errorHandler: { (asset) -> Void in
                self.imagesLeftToEval -= 1
                self.addPreviousReviewedPicture()
        })
    }
    
    func addUIDraggableFromLeft(uiDraggable: UIDraggableView){
        uiDraggable.center = CGPointMake(-uiDraggable.frame.width, uiDraggable.center.y)
        uiDraggable.alpha = 0.9
        uiDraggable.rightImage.alpha = 1
        uiDraggable.transform = CGAffineTransformMakeRotation(-0.2)
        self.view.addSubview(uiDraggable)

        UIView.animateWithDuration(ANIMATION_TIME,
            delay:0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
               uiDraggable.center = uiDraggable.originalCenter
                uiDraggable.alpha = 1
                uiDraggable.rightImage.alpha = 0
                uiDraggable.transform = CGAffineTransformMakeRotation(0)
            },
            completion: { finished in
            }
        )
    }
    
    func addUIDraggableFromRight(uiDraggable: UIDraggableView){
        uiDraggable.center = CGPointMake(self.view.frame.width + uiDraggable.frame.width , uiDraggable.center.y)

        uiDraggable.alpha = 0.9
        uiDraggable.leftImage.alpha = 1
        uiDraggable.transform = CGAffineTransformMakeRotation(0.2)
        self.view.addSubview(uiDraggable)
        
        UIView.animateWithDuration(ANIMATION_TIME,
            delay:0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                uiDraggable.center = uiDraggable.originalCenter
                uiDraggable.alpha = 1
                uiDraggable.leftImage.alpha = 0
                uiDraggable.transform = CGAffineTransformMakeRotation(0)
            },
            completion: { finished in
                
            }
        )
    }
    
    func setDeleteTitleLabel(){
        if(self.assetsToDelete.count > 0){
            self.skipRestButton.title = "Delete (\(self.assetsToDelete.count))"
        }
        else {
            self.skipRestButton.title = ""
        }
    }
    
    func decrementSizeOfTrash(uiDraggable: UIDraggableView){
        let trashed = self.getImageSize(uiDraggable.backgroundImage.image!)
        self.sizeTrashedFloat -= trashed.floatValue
        self.setTrashSize()
    }
    
    func incrementSizeOfTrash(uiDraggable: UIDraggableView){
        let trashed = self.getImageSize(uiDraggable.backgroundImage.image!)
        self.sizeTrashedFloat += trashed.floatValue
        self.setTrashSize()
    }
    
    func setTrashSize(){
        var size = NSString(format: "%.01f", self.sizeTrashedFloat)
        if(size.containsString("-")){
            size = size.substringFromIndex(1)
        }
        self.sizeTrashed.text = "\(size) MB in trash"
    }
    
    func getPreviousAssetEvaulated() -> PHAsset {
        if(self.imagesLeftToEval - 1 < 0){
            return self.tmpAssets[0]
        }
        return self.tmpAssets[self.imagesLeftToEval]
    }
    
    func fetchNextAsset(forceLoadIndex: Bool, jumpIndex: Int){
        if(self.imagesLeftToEval == 0){
            self.leftActionBarButton.title = "Undo"
        }
        
        self.imagesLeftToEval += 1
        if (self.uiDraggablesArray.count > 1){
            self.uiDraggablesArray[self.uiDraggablesArray.count - 2].userInteractionEnabled = true
        }
        else if (self.uiDraggablesArray.count == 0){
            
        }
        else {
            self.uiDraggablesArray[0].userInteractionEnabled = true
        }
        if (self.tmpAssets.count <= self.imagesLoaded){
            return
        }
        
        var tmpIndex = self.imagesLoaded
        if(forceLoadIndex && jumpIndex < self.tmpAssets.count){
            tmpIndex = jumpIndex
        }
        
        self.fetchImage(self.tmpAssets[tmpIndex], index: self.imagesLoaded,
            successHandler: { (res, asset) -> Void in
                self.imagesLoaded += 1
                let uiDraggable = self.createUiDraggableView(res, imageAsset: asset, imageNumber: self.imagesLoaded)
                self.updateQueuePointers(asset, uiDragable: uiDraggable)
                self.view.insertSubview(uiDraggable, aboveSubview: self.containerView)
                self.updateUserInteraction()
            },
            errorHandler: { (asset, index) -> Void in
                self.imagesLoaded += 1
                self.fetchNextAsset(false, jumpIndex: 0)
        })
    }
    
    func dissmissMyViewController(view: UIViewController, toStartView: Bool, animated: Bool, title: String, msg: String){
        if (toStartView) {
            self.navigationController?.popViewControllerAnimated(false)
            self.delegate?.dissmissMyViewController(self, toStartView: true, animated: false, title: title, msg: msg)
        }
        else if(self.isNoMoreImages()){
            self.navigationController?.popViewControllerAnimated(true)
            self.delegate?.dissmissMyViewController(self, toStartView: true, animated: false, title: title, msg: msg)
        }
        else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func goToGridView(){
        if(self.shouldPerformSegueWithIdentifier("GO_TO_GRID", sender: self)){
            self.performSegueWithIdentifier("GO_TO_GRID", sender: self);
        }
    }
    
    func updateQueuePointers(imageAsset: PHAsset, uiDragable: UIDraggableView){
        self.assetsLeftToEvaluate.insert(imageAsset, atIndex: 0)
        self.uiDraggablesArray.insert(uiDragable, atIndex: 0)
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(self.assetsLeftToEvaluate.count == 0 && self.assetsToDelete.count == 0){
            let alertController = UIAlertController(title: "Nothing trashed", message:
                "You have decided to keep all your pictures", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Back to start", style: UIAlertActionStyle.Default, handler: { action in
                self.navigationController?.popViewControllerAnimated(true)
                self.dismissViewControllerAnimated(true, completion:nil)
            }))
            self.presentViewController(alertController, animated: true, completion:nil)
            return false
        }
        
        if(self.assetsToDelete.count == 0){
            let alertController = UIAlertController(title: "Trash can empty", message:
                "There is no pictures to trash yet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { action in
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            if (segue.identifier == "GO_TO_GRID")
            {
                let vc = segue.destinationViewController as! GridViewController
                vc.images = self.assetsToDelete
                vc.delegate = self
                vc.megaBytesToClean = self.sizeTrashedFloat
            }
    }
    
    func animateUIDraggableOutFromScreen(view: UIDraggableView, leftImageAlpha: CGFloat, rightImageAlpha: CGFloat, center: CGPoint, rotation: CGFloat) {
        UIView.animateWithDuration(0.15,
            delay:0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                view.leftImage.alpha = leftImageAlpha
                view.rightImage.alpha = rightImageAlpha
                view.center = center
                view.transform = CGAffineTransformMakeRotation(rotation)
            },
            completion: { finished in
                view.removeFromSuperview()
            }
        )
    }
    
    func isBeingTapped(uiImageView: UIImageView) {
        self.navigationController?.navigationBarHidden = true
        let scrollView: PinchZoomView = PinchZoomView(imageView: uiImageView, frame:CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        scrollView.transform = CGAffineTransformMakeScale(0.95, 0.83);
        UIView.animateWithDuration(0.2, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
            animations:{
//                scrollView.transform = CGAffineTransformIdentity
                scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            },
            completion: { finished in
            }
        );
    }
    
    func setNavigationBarVisible() {
        self.navigationController?.navigationBarHidden = false
    }
    
    func isBeingDragged(view: UIDraggableView) {

    }
}