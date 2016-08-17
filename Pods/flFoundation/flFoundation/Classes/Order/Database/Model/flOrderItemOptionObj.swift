//
//  flOrderItemOptionObj.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/23/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

struct flOrderItemOptionObj {
    var id: String
    var title: String
    var amount: NSDecimalNumber
    
    func dictionary() -> ObjcDictionary {
        var output = ObjcDictionary()
        output["id"] = id
        output["title"] = title
        output["amount"] = amount
        return output
    }
}
