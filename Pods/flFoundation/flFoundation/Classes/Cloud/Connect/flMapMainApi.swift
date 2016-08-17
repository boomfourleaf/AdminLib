//
//  flMapMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flMapMainApi: flApi {
    override init() {
        super.init()
        api = "map/get_travel_interests/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/<filepdf>"]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.MAP, fileName:"map.plist")
    }
}