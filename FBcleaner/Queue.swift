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
    var assets: [PHAsset] = []
    var pos: Int = 0
    
    func getNextAsset() -> PHAsset {
        let asset = self.assets[self.pos]
        self.pos += 1
        return asset
    }
    
    func getPreviousAsset() -> PHAsset! {
        self.pos -= 1
        return self.assets[self.pos]
    }
    
    func removeAssetAtIndex(index: Int) {
        self.assets.removeAtIndex(index)
    }
    
}