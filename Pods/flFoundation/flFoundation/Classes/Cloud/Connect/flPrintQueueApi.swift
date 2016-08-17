//
//  flPrintQueueApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/5/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public class flPrintQueueApi: flApi {
    public override init() {
        super.init()
        api = "order/print_queues/[random]/"
        parameters = []
    }
}

public class flPrintQueueDeleteApi: flApi {
    public override init() {
        super.init()
        api = "order/print_queues_delete/[fuid]/"
    }
}
