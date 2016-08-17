//
//  flCloseShiftApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/20/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flCloseShiftPrepareApi: flApi {
    public override init() {
        super.init()
        api = "order/close_shift_prepare/invoice/[random]/"
        parameters = []
    }
}

public class flCloseShiftApi: flApi {
    public override init() {
        super.init()
        api = "order/close_shift/{0}/[random]/"
        parameters = []
    }
}
