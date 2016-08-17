//
//  flLanguageApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flLanguageApi: flApi {
    public override init() {
        super.init()
        api = "setting/language/[fuid]/{0}/[random]/"
        parameters = ["DIN"]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.LANGUAGE, fileName:"language.plist")
    }
}
