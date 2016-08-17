//
//  flSpecialMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flSpecialMainApi: flApi {
    public override init() {
        super.init()
        api = "special_offer/get_specials/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/[items]/<picture>"]
    }
    
    public override func imageResizeTo() -> [[String]] {
        return [["600x400"]]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.SPECIAL_CATEGORY, fileName:"specialOffer.plist")
    }
}
