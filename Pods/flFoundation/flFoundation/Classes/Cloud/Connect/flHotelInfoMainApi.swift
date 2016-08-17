//
//  flHotelInfoMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flHotelInfoMainApi: flApi {
    public override init() {
        super.init()
        api = "hotel_info/get_info/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/<picture>"]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.HOTEL_INFO, fileName:"hotel_info.plist")
    }
}
