//
//  flImageCache.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/6/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public class flImageCache {
    public var url: String
    public var hash: String
    
    public init() {
        url = ""
        hash = ""
    }
    
    public init(url: String, hash: String) {
        self.url = url
        self.hash = hash
    }
    
    
    private var _md5 = ""
    
    public static func isSynced(url: String, forHash hash: String) -> Bool {
        // create instant
        let imageCache = flImageCache(url: url, hash: hash)
        
        // check if file exist
        let storedHash = flPersistData.objForKey(imageCache.md5WithHash()) as? String
        if storedHash == hash {
            return true
        }
        
        return false
    }
    
    public static func imagePathFor(url: String, forHash hash: String) -> String {
        // create instant
        let imageCache = flImageCache(url: url, hash: hash)
        
        return imageCache.imagePath()
    }
    
    public static func imagePathForData(data: PictureData) -> String {

        // create instant
        let imageCache = flImageCache(url: data.url, hash: data.hash)
        
        return imageCache.imagePath()
    }
    
    public func imagePath() -> String {
        // get file path
        let fileName = "\(md5()).\((url as NSString).pathExtension)"
        
        let filePath = flFile.absolutePathFor(.IMAGE, fileName:fileName)
        
        return filePath
    }
    
    public func syncImageToFile() -> Bool {
        guard let urlString = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            let realUrl = NSURL(string: urlString) else { return false }
        
        guard let data = NSData(contentsOfURL:realUrl) else  {return false }
        
        if Int(hash) != data.length {
            return false
        }
        
        data.writeToFile(imagePath(), atomically:true)
        
        flPersistData.setObj(hash, forKey:md5WithHash())
        
        
        flLog.info("image hash \(data.hash) \(hash) \(data.length)")
        
        return true
    }
    
    // Private
    private func md5() -> String {
        // generate md5 if there are not exist
        if _md5 == "" {
            let longName = "\(hash)\(url)"
            _md5 = longName.MD5()
        }
        
        return _md5
    }
    
    private func md5WithHash() -> String {
        return md5() + "HASH"

    }
    
}