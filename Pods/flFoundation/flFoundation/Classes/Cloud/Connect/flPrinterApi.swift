//
//  flPrinterApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/25/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flPrinterNewJobApi: flApi {
    public override init() {
        super.init()
        api = "order/thermal_print_new_order/{0}/{1}/[random]/full_status/"
    }
}
