//
//  flActivationApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/21/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import UIKit

public class flActivationApi: flApi {
    public static let shareObject = flActivationApi()
    
    public override init() {
        super.init()
        api = "license/activate/[fuid]/[random]/"
        parameters = []
    }
    
    public override func rootUrl() -> String {
        return "https://reseller.afourleaf.com"
    }
}

public class flActivationWithLicenseApi: flApi {
    public static let shareObject = flActivationWithLicenseApi()

    public override init() {
        super.init()
        api = "license/activate_license/[fuid]/"
        parameters = []
    }
    
    public override func rootUrl() -> String {
        return "https://reseller.afourleaf.com"
    }
}
