//
//  flHousekeepingMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flHousekeepingMainApi: flApi {
    public override init() {
        super.init()
        api = "house_keeping/get_housekeeping_services/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/<picture>"]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.HOUSE_KEEPING, fileName:"housekeeping.plist")
    }
}

//MARK: House Keeping Order API
public class flHousekeepingOrderApi: flApi {
    public override init() {
        super.init()
        api = "order/order_house_keeping/[fuid]/"
    }
}

//MARK: Order History
public class flHousekeepingOrderHisApi: flApi {
    public override init() {
        super.init()
        api = "order/order_house_keeping_history/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.HOUSE_KEEPING, fileName:"housekeepingOrderHistory.plist")
    }
}
