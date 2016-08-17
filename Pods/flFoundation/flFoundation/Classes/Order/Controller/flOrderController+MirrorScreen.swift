//
//  flOrderController+MirrorScreen.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/7/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

extension flOrderController {
    public func mirroOrderScreenJson() -> JSON {
        let tableZone: String
        let tableName: String
        let tableSplit: Int
        if let table = self.table {
            tableZone = table.zone
            tableName = table.name
            tableSplit = table.split
        } else {
            tableZone = ""
            tableName = ""
            tableSplit = 0
        }
        
        var data = JSON([["table_zone": tableZone,
            "table_name": tableName,
            "table_split": tableSplit]])
        
        data[0]["items"] = [["status": "ORD",
            "billing_id": "FOURLEAF",
            "note": "",
            "price": dec(self.totalPrice()),
            "price_option": "currency_decimal_comma",
            "subtotal": dec(self.totalPriceWithoutServiceChargeAndVat()),
            "id": 4,
            "assign_room_number": ""]]
        
        var items: [ObjcDictionary] = []
        for item in self.getListOfDict() {
            
            var modifiedItem = item
            
            // Final price compound with option price, then remove option price
            let final_price = item["final_price"] as? CGFloat ?? 0
            let option_price = item["option_price"] as? CGFloat ?? 0
            
            modifiedItem["final_price"] = final_price + option_price
            modifiedItem["option_price"] = 0.0
            
            var itemId = item["itemId"] as? String ?? ""
            itemId = "DIN_" + itemId
            modifiedItem["item_id"] = itemId
            modifiedItem["price_option"] = "currency_decimal_comma"
            modifiedItem["final_price_option"] = "currency_decimal_comma"
            
            items.append(modifiedItem)
        }
        
//        var itemsOutput: [ObjcDictionary] = self.list.map { item in
//            let price = dec(item.final_price + item.option_price)
//            let amount = item.amount
//            
//            let dataDict: ObjcDictionary = [
//                "id": 4,
//                "item_id": "DIN_4",
//                "name": item.displayName ?? "",
//                "name_order": item.nameOrder ?? "",
//                "name_invoice": item.nameInvoice ?? "",
//                "option": "",
//                "option_order": "",
//                "price": price,
//                "price_option": "currency_decimal_comma",
//                "final_price": price,
//                "final_price_option": "currency_decimal_comma",
//                "amount": amount,
//                "note": "",
//                "code": "",
//                "sensitive": false]
//            return dataDict
//        }
//        data[0]["items"][0]["items"] = JSON(itemsOutput)
        data[0]["items"][0]["items"] = JSON(items)
        
        return data
    }
    
    public func mirroOrderScreenJsonString() -> String? {
        return mirroOrderScreenJson().rawString()
    }
}
