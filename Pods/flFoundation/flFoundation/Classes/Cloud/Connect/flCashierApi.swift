//
//  flCashierApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flCashierDiscountPercentApi: flApi {
    public override init() {
        super.init()
        api = "order/discount_percent_with_filters/[fuid]/[random]/"
    }
}

public class flCashierChangeOrderStatusApi: flApi {
    public override init() {
        super.init()
        api = "order/change_order_status/[random]/"
    }
}

public class flCashierOrderLogApi: flApi {
    public override init() {
        super.init()
        api = "order/order_log/[random]/json/"
    }
}

public class flCashierOpenCashDrawerApi: flApi {
    public override init() {
        super.init()
        api = "order/open_cash_drawer/[fuid]/{0}/[random]/"
    }
}
