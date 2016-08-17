//
//  flLogApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flLogPrintQueueApi: flApi {
    public override init() {
        super.init()
        api = "log/save_print_queue/[fuid]/"
    }
}


public class flLogPrintLogApi: flApi {
    public override init() {
        super.init()
        api = "log/save_print_log/[fuid]/"
    }
}

public class flLogPrintSuccessApi: flApi {
    public override init() {
        super.init()
        api = "log/save_print_success/[fuid]/"
    }
}

