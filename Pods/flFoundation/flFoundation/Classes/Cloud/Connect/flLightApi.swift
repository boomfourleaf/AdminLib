//
//  flLightApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

//MARK: Light Api
public class flLightApi: flApi {
    public override init() {
        super.init()
        api = "room_control/light_set/{0}/"
    }
}

//MARK: Light Set Api
public class flLightSetApi: flApi {
    public override init() {
        super.init()
        api = "room_control/light_set/{0}/"
    }
}
