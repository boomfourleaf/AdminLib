//
//  flFirstAidApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flFirstAidApi: flApi {
    public override init() {
        super.init()
        api = "first_aid/get_first_aids/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.FIRST_AID_CATEGORY, fileName:"first_aid.plist")
    }
}
