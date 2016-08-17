//
//  flApi+SyncImage.swift
//  Pods
//
//  Created by Nattapon Nimakul on 7/5/2559 BE.
//
//

import Foundation
import SwiftyJSON

public typealias PictureData = (url: String, hash: String)

extension flApi {
    public static func getPicData(plist: JSON, name: String) -> PictureData {
        // Generate Dict
        // ['picture': 'http://xxxx.png',
        //  'picture_hash': '97964803802942529']
//        return [API_URL_TAG: plist[name].stringValue, API_HASH_TAG: plist[name + "_hash"].stringValue]
        return PictureData(url: plist[name].stringValue, hash: plist[name + "_hash"].stringValue)
    }
    
    public static func syncImage(pictureData: PictureData) -> Bool {
        let url = pictureData.url
        let hash = pictureData.hash
        
        let imageCahce = flImageCache()
        imageCahce.url = url
        imageCahce.hash = hash
        
        if flImageCache.isSynced(url, forHash:hash) {
            flLog.info("alredy sync")
            return true

        } else {
            flLog.info("dl \(url) \(hash)")
            
            // If failed, record fail state and go next
            var isSyncSuccess = false
            autoreleasepool {
                isSyncSuccess = imageCahce.syncImageToFile()
            }
            
            if isSyncSuccess {
                // Double check if file exist
                if flFile.isExist(imageCahce.imagePath()) {
                    return true

                } else {
                    flLog.error("image url \(url)")
                    flLog.error("image file \(imageCahce.imagePath())")
                    flLog.error("download image failed, image deos not store properly")
                    flLog.error("------------------------------------------------------")
                    return false
                }
                
            } else {
                flLog.error("download failed url:\(url) hash:\(hash)")
                return false
            }
        }
    }

    // download image with given url
    public func downloadImages(urls: [PictureData], `try` tryAmount: Int) -> Bool {
        var isAnyDownloadFailed = false
        
        for _ in 0 ..< tryAmount {
            isAnyDownloadFailed = false
            finishedDownloadedImages = 0
            
            for pictureData in urls {
                
                let isSyncSuccess = flApi.syncImage(pictureData)
                
                if !isSyncSuccess {
                    isAnyDownloadFailed = true
                    continue
                }
                
                self.finishedDownloadedImages += 1
            }
            
            // End task, If everything's going OK
            if !isAnyDownloadFailed {
                break
            }
        }
        
        return !isAnyDownloadFailed;
    }
    
    // download image with given url
    public func downloadImages(urls: [PictureData]) -> Bool {
        return downloadImages(urls, try:1)
    }
}
