//
//  flGalleryMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flGalleryMainApi: flActivityCategoryApi {
    public override init() {
        super.init()
        api = "gallery/get_galleries/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/[items]/<picture>",
                "[datas]/[items]/[items]/<picture>",
                "[datas]/[items]/[items]/<thumbnail>"]
    }
    
    public override func imageResizeTo() -> [[String]] {
        return [["600x410"],
                ["800x800"],
                ["800x800"]]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.GALLERY_CATEGORY, fileName:"gallery.plist")
    }
}
