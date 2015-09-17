//
//  ImageCacheController.swift
//  FBcleaner
//
//  Created by Simen Johannessen on 27/10/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import Photos


class ImageCacheController {
    private var cachedIndices = NSIndexSet()
    var cachePreheatSize: Int
    var imageCache: PHCachingImageManager
    var images: [PHAsset] = []
    var targetSize: CGSize!
    var contentMode = PHImageContentMode.AspectFill
    
    init(imageManager: PHCachingImageManager, images: [PHAsset], preheatSize: Int = 1) {
        self.cachePreheatSize = preheatSize
        self.imageCache = imageManager
        self.images = images
    }
    
    func updateVisibleCells(visibleCells: [NSIndexPath]) {
        let initialRequestOptions = PHImageRequestOptions()
        initialRequestOptions.networkAccessAllowed = true
        initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        
        let updatedCache = NSMutableIndexSet()
        for path in visibleCells {
            updatedCache.addIndex(path.item)
        }
        let minCache = max(0, updatedCache.firstIndex - cachePreheatSize)
        let maxCache = min(self.images.count - 1, updatedCache.lastIndex + cachePreheatSize)
        updatedCache.addIndexesInRange(NSMakeRange(minCache, maxCache - minCache + 1))
        
        // Which indices can be chucked?
        self.cachedIndices.enumerateIndexesUsingBlock {
            index, _ in
            if !updatedCache.containsIndex(index) {
                let asset = self.images[index]
                self.imageCache.stopCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: initialRequestOptions)
            }
        }
        
        // And which are new?
        updatedCache.enumerateIndexesUsingBlock {
            index, _ in
            if !self.cachedIndices.containsIndex(index) {
                let asset  = self.images[index]
                self.imageCache.startCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: initialRequestOptions)
            }
        }
        cachedIndices = NSIndexSet(indexSet: updatedCache)
    }
}