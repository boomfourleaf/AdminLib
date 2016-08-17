//
//  flPrinterRasterProtocol.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/5/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public protocol flPrinterRasterProtocol: flPrinterProtocol {
    
}

extension flPrinterRasterProtocol {
    public func feed(feed: Int) -> PRINTER_STATUS {
        let size = CGSizeMake(CGFloat(lineWidth), CGFloat(feed / 8))
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        let ctr = UIGraphicsGetCurrentContext()
        UIColor.whiteColor().set()
        let rect = CGRectMake(0, 0, size.width + 1, size.height + 1)
        CGContextFillRect(ctr, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let returnOutput = printImage( image )
        
        return returnOutput
    }
    
    public func adjustFontSize(size: CGFloat) -> CGFloat {
        return size + 7.0
    }
}

//MARK: Helper
extension flPrinterRasterProtocol {
    // composite Cacahed Images for Portable Mode
    public static func compositeImages(imageCaches: [UIImage]) -> UIImage {
        guard imageCaches.count > 0 else { return UIImage() }
        
        let height = imageCaches.reduce(CGFloat(0)) { $0 + $1.size.height }
        let width = imageCaches.reduce(CGFloat(0)) { max($0, $1.size.width) }
        let size = CGSizeMake(width, height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        let ctr = UIGraphicsGetCurrentContext()
        // Background
        UIColor.whiteColor().set()
        let rect = CGRectMake(0, 0, size.width + 1, size.height + 1)
        CGContextFillRect(ctr, rect)
        
        // Draw all images
        var currrentY = CGFloat(0)
        for imageCache in imageCaches {
            imageCache.drawInRect(CGRectMake(0, currrentY, imageCache.size.width, imageCache.size.height))
            currrentY += imageCache.size.height
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
