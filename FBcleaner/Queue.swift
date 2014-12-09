//
//  Queue.swift
//  Photo Trasher
//
//  Created by Simen Johannessen on 07/12/14.
//  Copyright (c) 2014 Simen Johannessen. All rights reserved.
//

import Foundation
import Photos

class Queue {
    var uiDraggableArray: [UIDraggableView] = []
    var assets: [PHAsset] = []
    var assetPos: Int = 0
    var draggablePos: Int = 0
    
    // ASSETS
    func getNextAsset() -> PHAsset? {
        if(assetPos >= self.assets.count) {
            return nil
        }
        
        let asset = self.assets[self.assetPos]
        self.assetPos += 1
        return asset
    }
    
    func getPreviousAsset() -> PHAsset? {
        if (self.assetPos <= 0) {
            self.assetPos -= 1
        }
        
        return self.assets[self.assetPos]
    }
    
    func removeAsset(){
        self.assets.removeLast()
    }
    
    func removeAssetAtIndex(index: Int) {
        self.assets.removeAtIndex(index)
    }
    
    func insertAsset(asset: PHAsset) {
        self.assets.insert(asset, atIndex: 0)
    }
    
    // UIDRAGGABLE
    func getUiDraggable() -> UIDraggableView? {
        return self.uiDraggableArray.last
    }
    
    func insertUiDraggable(uiDraggable: UIDraggableView) {
        self.uiDraggableArray.insert(uiDraggable, atIndex: 0)
    }
    
    func getUiDraggablesArray() -> [UIDraggableView] {
        return self.uiDraggableArray
    }
    
    func removeUiDraggable() {
        self.uiDraggableArray.removeLast()
    }
}