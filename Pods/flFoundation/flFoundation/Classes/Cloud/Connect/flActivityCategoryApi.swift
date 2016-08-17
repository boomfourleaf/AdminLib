//
//  flActivityCategoryApi.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/24/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

//MARK: Activity
public class flActivityCategoryApi: flApi {
    override init() {
        super.init()
        api = "activity/get_activities/[fuid]/[random]/"
    }
    
    public override func imageAndDataPaths() -> [String] {
        return ["[datas]/[items]/<picture>",
                "[datas]/[items]/[items]/<picture>",
                "[datas]/[items]/[gallery]/<picture>"]
    }
    
    public override func imageResizeTo() -> [[String]] {
        return [
        [],
        ["800x600"],
        ["800x600"]]
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.ACTIVITY_CATEGORY, fileName:"activityCategory.plist")
    }
    
    public override func beforeFinishRun(plist: ObjcDictionary) -> Bool {
        // Do something after download all datas
        
        if let datas = plist[API_ROOT_DATAS] as? [ObjcDictionary] {
            for rowData in datas {
                if let items = rowData["items"] as? [ObjcDictionary] {
                    for item in items {
                        // Half Cell
                        var success = true
                        autoreleasepool {
                            success = blendImage(item, name: "picture", withBlendImage: "blend4.png", outSuffixName: "_blend1")
                        }
                        if !success { return false }
                        
                        // Full Cell
                        autoreleasepool {
                            success = blendImage(item, name: "picture", withBlendImage: "blend5.png", outSuffixName: "_blend2")
                        }
                        if !success { return false }
                        
                        // Half Tall Cell
                        autoreleasepool {
                            success = blendImage(item, name: "picture", withBlendImage: "blend6.png", outSuffixName: "_blend3")
                        }
                        if !success { return false }
                        
                        // Full Tall Cell
                        autoreleasepool {
                            success = blendImage(item, name: "picture", withBlendImage: "blend7.png", outSuffixName: "_blend4")
                        }
                        if !success { return false }
                    }
                }
            }
        }
        
        return true
    }
}


public class flActivityOrderApi: flApi {
    override init() {
        super.init()
        api = "order/order_activity/[fuid]/"
    }
}

//MARK: Spa
public class flSpaCategoryApi: flActivityCategoryApi {
    override init() {
        super.init()
        api = "activity/get_spas/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.SPA, fileName:"spaCategory.plist")
    }
}

public class flSpaOrderApi: flActivityOrderApi {
    override init() {
        super.init()
        api = "order/order_spa/[fuid]/"
    }
}

//MARK: Honeymoon
public class flCtHoneymoonCategoryApi: flActivityCategoryApi {
    override init() {
        super.init()
        api = "activity/get_honeymoons/[fuid]/[random]/"
    }
    
    public override func filePath() -> String {
        return flFile.absolutePathFor(.HONEYMOON, fileName:"honeymoonCategory.plist")
    }
}

public class flCtHoneymoonOrderApi: flActivityOrderApi {
    override init() {
        super.init()
        api = "order/order_honeymoon/[fuid]/"
    }
}

