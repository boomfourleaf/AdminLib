//
//  flWeatherMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flWeatherMainApi: flApi {
    override init() {
        super.init()
        api = "weather/get_weathers/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.WEATHER, fileName:"weather.plist")
    }
}
