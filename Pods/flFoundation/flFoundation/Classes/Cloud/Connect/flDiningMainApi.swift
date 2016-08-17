//
//  flDiningMainApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: Dining Main Api
public class flDiningMainApi: flApi {
    public override init() {
        super.init()
        api = "dining/get_menus/[fuid]/{0}/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/[items]/[items]/<picture>",
                "[datas]/<picture>",
                "[datas]/<cover_picture>",
                "[group_order]/<picture>",
                "[invoice_config]<hotel_logo>"]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.DINING, fileName:"dining.plist")
    }
    
    public override func beforeFinishRunCount(plist: ObjcDictionary) -> Int {
        var count = 0
        let plistJson = JSON(plist)
        for rowData in plistJson[API_ROOT_DATAS].arrayValue {
            for group in rowData["items"].arrayValue {
                for item in group["items"].arrayValue {
                    if let picture = item["picture"].string
                        where picture != "" {
                        count += 1
                    }
                }
            }
        }
        
        return count;
    }
    
    public override func beforeFinishRun(plist: ObjcDictionary) -> Bool {
        // Do something after download all datas
        finishedBeforeFinishRun = 0;
        
        let plistJson = JSON(plist)
        for rowData in plistJson[API_ROOT_DATAS].arrayValue {
            for group in rowData["items"].arrayValue {
                for item in group["items"].arrayValue {
                    if item["picture"].stringValue == "" {
                        continue
                    }
                    
                    if let itemDict = item.dictionaryObject {
                        // Half Cell
                        var success = true
                        autoreleasepool {
                            success = blendImage(itemDict, name: "picture", withBlendImage: "blend4.png", outSuffixName: "_blend1")
                        }
                        if !success { return false }
                        
                        // Full Cell
                        autoreleasepool {
                            success = blendImage(itemDict, name: "picture", withBlendImage: "blend5.png", outSuffixName: "_blend2")
                        }
                        if !success { return false }
                        
                        // Half Tall Cell
                        autoreleasepool {
                            success = blendImage(itemDict, name: "picture", withBlendImage: "blend6.png", outSuffixName: "_blend3")
                        }
                        if !success { return false }
                        
                        // Full Tall Cell
                        autoreleasepool {
                            success = blendImage(itemDict, name: "picture", withBlendImage: "blend7.png", outSuffixName: "_blend4")
                        }
                        if !success { return false }
                        
                        // Circle Cell
                        autoreleasepool {
                            success = blendImage(itemDict, name: "picture", withBlendImage: "blend_circle_90px.png", outSuffixName: "_blend_circle_90px")
                        }
                        if !success { return false }
                        
                        finishedBeforeFinishRun += 1
                    }
                }
            }
        }
        
        return true
    }
}

//MARK: Dining Order Api
public class flDiningOrderApi: flApi {
    public override init() {
        super.init()
        api = "order/order_dining/[fuid]/"
    }
}

//MARK: Dining Order - Check Status Api
public class flDiningOrderStatusApi: flApi {
    public override init() {
        super.init()
        api = "order/check_order_status/[fuid]/"
    }
}

//MARK: Dining Open Table List API
public class flDiningOpenTableListApi: flApi {
    public override init() {
        super.init()
        api = "order/open_table_list/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.DINING, fileName:"dining_open_table_list.plist")
    }
}

//MARK: Dining Open Table Order List API
public class flDiningOpenTableOrderListApi: flApi {
    public override init() {
        super.init()
        api = "order/open_table_order_list/[fuid]/{0}/{1}/{2}/{3}/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.DINING, fileName:"dining_open_table_order_list.plist")
    }
}

//MARK: Dining Open Bill List API
public class flDiningOpenBillListApi: flApi {
    public override init() {
        super.init()
        api = "order/open_bill_list/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.DINING, fileName:"dining_open_bill_list.plist")
    }
}

//MARK: Dining Open Bill Order List API
public class flDiningOpenBillOrderListApi: flApi {
    public override init() {
        super.init()
        api = "order/order_list_for_bill/[fuid]/{0}/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.DINING, fileName:"dining_open_bill_order_list.plist")
    }
}

//MARK: Dining Order Change Api
public class flDiningOrderChangeApi: flApi {
    public override init() {
        super.init()
        api = "order/change_order_items/[fuid]/"
    }
}

//MARK: Dining Order Move Api
public class flDiningOrderMoveApi: flApi {
    public override init() {
        super.init()
        api = "order/move_order_items/[fuid]/"
    }
}

//MARK: Dining Invoice Api
public class flDiningInvoiceApi: flApi {
    public override init() {
        super.init()
        api = "order/invoice_request/[fuid]/"
    }
}

//MARK: Dining Void Api
public class flDiningVoidApi: flApi {
    public override init() {
        super.init()
        api = "order/void_request/[fuid]/"
    }
}

//MARK: Dining Order Change Api
public class flDiningOrderChangeGuestAmountApi: flApi {
    public override init() {
        super.init()
        api = "order/change_table_guest_amount/[fuid]/"
    }
}

//MARK: Soap Api
public class flSoapApi: flApi {
    public override init() {
        super.init()
//        server = "http://202.183.217.190"
//        port = "8080"
        api = "/wInfpms/services/transaction"
    }
}
