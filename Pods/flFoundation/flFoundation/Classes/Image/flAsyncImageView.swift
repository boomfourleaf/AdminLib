//
//  flAsyncImageView.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/13/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol flAsyncImageView {
    func setAsyncImage(name: String)
}

extension flAsyncImageView {
    public func setImageWithPic(pic: String) {
        self.setAsyncImage(pic)
    }
    
    public func setImageWithData(data: JSON, imgName name: String) {
        let pic = flImageCache.imagePathForData(flApi.getPicData(data, name: name))
        setImageWithPic(pic)
    }
    
    public func setImageWithData(data: JSON, imgName name: String, prefer preferSize: CGSize) {
        let pic = flImageCache.imagePathForData(flApi.getPicData(data, name: name))
        let preferPath = flResizeImage.imagePath(pic, atSize: preferSize)
        
        if flFile.isExist(preferPath) {
            setImageWithPic(preferPath)
        } else {
            setImageWithPic(pic)
        }
    }
    
    public func setImageWithData(data: JSON) {
        setImageWithData(data, imgName: "picture")
    }
    
    public func setImageWithData(data: JSON, prefer preferSize: CGSize) {
        setImageWithData(data, imgName: "picture", prefer: preferSize)
    }
}
