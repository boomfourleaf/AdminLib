//
//  flResizeImage.swift
//  Dining
//
//  Created by Nattapon Nimakul on 8/18/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

final class flResizeImage {
    class func scaleImage(image: UIImage, toResolution resolution: Int) -> UIImage {
        let width: CGFloat
        let height: CGFloat
        if let imgRef = image.CGImage {
            width = CGFloat(CGImageGetWidth(imgRef))
            height = CGFloat(CGImageGetHeight(imgRef))
        } else {
            width = image.size.width
            height = image.size.height
        }
        var bounds = CGRectMake(0, 0, width, height)
        
        //if already at the minimum resolution, return the orginal image, otherwise scale
        if width <= CGFloat(resolution) && height <= CGFloat(resolution) {
            return image
            
        } else {
            let ratio = width/height
            
            if ratio > 1 {
                bounds.size.width = CGFloat(resolution)
                bounds.size.height = bounds.size.width / ratio
            } else {
                bounds.size.height = CGFloat(resolution)
                bounds.size.width = bounds.size.height * ratio
            }
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        image.drawInRect(CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height))
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy.fixOrientation()
    }
    
    class func scaleImage(image: UIImage, cropToSize toSize: CGSize) -> UIImage {
        let originWidth: CGFloat
        let originHeight: CGFloat
        if let imgRef = image.CGImage {
            originWidth = CGFloat(CGImageGetWidth(imgRef))
            originHeight = CGFloat(CGImageGetHeight(imgRef))
        } else {
            originWidth = image.size.width
            originHeight = image.size.height
        }
        let originSize = CGSizeMake(originWidth, originHeight)
        
        let originRatio = originSize.width / originSize.height
        let toRatio = toSize.width / toSize.height
        
        UIGraphicsBeginImageContext(toSize)
        
        // crop top, down
        if toRatio > originRatio {
            var drawRect = CGRectZero
            drawRect.size.width = toSize.width
            drawRect.size.height = toSize.width / originRatio
            drawRect.origin.y = 0 - (drawRect.size.height - toSize.height) / 2
            image.drawInRect(drawRect)
            
        // crop left, right
        } else {
            var drawRect = CGRectZero
            drawRect.size.width = toSize.height * originRatio
            drawRect.size.height = toSize.height
            drawRect.origin.x = 0 - (drawRect.size.width - toSize.width) / 2
            image.drawInRect(drawRect)
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy.fixOrientation()
    }
    
    class func imagePath(originImagePath: String, atSize size: CGSize) -> String {
        let fileName = ((originImagePath as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
        let path = (originImagePath as NSString).stringByDeletingLastPathComponent
        
        
        let newFileName = fileName + String(format: "_%.0fx%.0f.%@", size.width, size.height, (originImagePath as NSString).pathExtension)
        let newPath = (path as NSString).stringByAppendingPathComponent(newFileName)
        
        return newPath
    }
    
    class func isExist(originImagePath: String, atSize size: CGSize) -> Bool {
        let newPath = flResizeImage.imagePath(originImagePath, atSize:size)
        return flFile.isExist(newPath)
    }
    
    class func createImage(originImagePath: String, atSize size: CGSize) -> Bool {
        let path = flResizeImage.imagePath(originImagePath, atSize:size)
        
        // Not recreate if exist
        let isExist = flFile.isExist(path)
        if isExist {
            return true
        }
        
        guard let imageData = NSData(contentsOfURL:NSURL(fileURLWithPath:originImagePath)) else { return false }
        guard var image = UIImage(data:imageData) else { return false }
        if image.size.width <= size.width {
            return false
        }
        
        var scaleFactor = CGFloat(1.0)
        if .Scale2x == flScreenScale.mainScreenScale {
            scaleFactor = 2.0
        }
        scaleFactor = 1.0
        
//        image = flResizeImage.scaleImage(image, toResolution:Int(max(size.width * scaleFactor, size.height * scaleFactor)))
        image = flResizeImage.scaleImage(image, cropToSize: CGSizeMake(size.width * scaleFactor, size.height * scaleFactor))
        
        flLog.info("image \(image) \(path)")
        
        if let imagePng = UIImagePNGRepresentation(image) {
            imagePng.writeToFile(path, atomically:true)
            return true
        } else {
            return false
        }
    }
}
