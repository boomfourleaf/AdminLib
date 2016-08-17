//
//  flVC+Image.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation
import SwiftyJSON

extension flVC {
    // MARK: - Image Processing
    public static func urlPicWithData(data: JSON, name: String, suffix: String, targetExtension: String) -> NSURL? {
        let path = flImageCache.imagePathForData(flApi.getPicData(data, name: name))
        let pathWithSuffix = path.addSuffix(suffix, withExtension: targetExtension)
        path.addSuffix(suffix, withExtension: targetExtension)
        
        if !flFile.isExist(pathWithSuffix) {
            flLog.info("path \(path)")

            if !flFile.isExist(path) {
                return nil
            } else {
                return NSURL(fileURLWithPath: path)
            }
            
        } else {
            flLog.info("path \(path)")
            if let uwpPathWithSuffix = pathWithSuffix {
                return NSURL(fileURLWithPath: uwpPathWithSuffix)
            }
        }
        
        return nil
    }
    
    public static func urlPicWithData(data: JSON, name: String, suffix: String) -> NSURL? {
        let pathWithSuffix = flImageCache.imagePathForData(flApi.getPicData(data, name: name)).addSuffix(suffix)
        if !flFile.isExist(pathWithSuffix) {
            return nil
        } else {
            return NSURL(fileURLWithPath: pathWithSuffix)
        }
    }
    
    public static func urlPicWithData(data: JSON, name: String) -> NSURL? {
        let path = flImageCache.imagePathForData(flApi.getPicData(data, name: name))
        if !flFile.isExist(path) {
            return nil
        } else {
            return NSURL(fileURLWithPath: path)
        }
    }
}
