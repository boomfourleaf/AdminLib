//
//  flOrderItem.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/9/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import RealmSwift

public final class flOrderItem: Object {
    public dynamic var id = 0
    
    public dynamic var name = ""
    public dynamic var name_order = ""
    public dynamic var name_invoice = ""
    public dynamic var item_id = ""
    public dynamic var amount = 0
    public dynamic var price = "0"
    public dynamic var final_price = "0"
    
    public dynamic var option = ""
    public dynamic var option_order = ""
    public dynamic var option_invoice = ""
    public dynamic var note = ""
    public dynamic var code = ""
    public dynamic var sensitive = false
    
    public static func newItem(realm: Realm) -> flOrderItem {
        let item = flOrderItem()
        item.id = flOrderItem.newId(realm)
        return item
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public override static func ignoredProperties() -> [String] {
        return []
    }
    
    public static func cloneWithoutSync(fromItem: flOrderItem) -> flOrderItem {
        let newItem = flOrderItem()
        
        newItem.id = fromItem.id
        newItem.name = fromItem.name
        newItem.name_order = fromItem.name_order
        newItem.name_invoice = fromItem.name_invoice
        newItem.item_id = fromItem.item_id
        newItem.amount = fromItem.amount
        newItem.price = fromItem.price
        newItem.final_price = fromItem.final_price
        
        newItem.option = fromItem.option
        newItem.option_order = fromItem.option_order
        newItem.option_invoice = fromItem.option_invoice
        newItem.note = fromItem.note
        newItem.code = fromItem.code
        newItem.sensitive = fromItem.sensitive
        
        return newItem
    }
}

//MARK: ID Generator
extension flOrderItem {
    public static func newId(realm: Realm) -> Int {
        if let maxId = realm.objects(flOrderItem).max("id") as Int? {
            return maxId + 1
        } else {
            return 1
        }
    }
}
