//
//  flOrder.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/9/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

public final class flOrder: Object {
    public dynamic var id = 0
    
    public dynamic var table_zone = ""
    public dynamic var table_name = ""
    public dynamic var table_split = 0
    public dynamic var guest_amount = 0
    public dynamic var total = "0"
    public dynamic var subtotal = "0"
    
    public dynamic var service_charge = "0"
    public dynamic var vat = "0"
    public dynamic var misc = "0"
    public dynamic var discount = "0"
    public dynamic var discount_label = "0"
    
    public dynamic var status = "ORD"
    public dynamic var purchase_date = NSDate()
    public dynamic var note = ""
    
    public let items = List<flOrderItem>()
    
    public static func newOrder(realm: Realm) -> flOrder {
        let order = flOrder()
        order.id = flOrder.newId(realm)
        return order
    }
    
    public var table: flTableObj {
        return flTableObj(zone: table_zone, name: table_name, split: table_split)
    }
    
    public var billing_id: String {
        return String(format: "FL%05d", id)
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public override static func ignoredProperties() -> [String] {
        return []
    }
    
    public static func getOrders(realm: Realm) -> [flOrder] {
        let orders = realm.objects(flOrder)
        return Array(orders)
    }
    
    public static func addNewOrder(order: flOrder, realm: Realm) {
        if 0 == order.id {
            order.id = flOrder.newId(realm)
        }
        
        realm.add(order, update: true)
    }
}

//MARK: ID Generator
extension flOrder {
    public static func newId(realm: Realm) -> Int {
        if let maxId = realm.objects(flOrder).max("id") as Int? {
            return maxId + 1
        } else {
            return 1
        }
    }
}

extension flOrder {
    public var toCashierJson: JSON {
        return ["id": id,
                "name": table.display(),
                "purchase_date": purchase_date.dateDayMonthYearAndTimeShort() ?? "",
                "status": status,
                "total": total,
                "total_option": "currency_decimal_comma",
                "discount": discount,
                "discount_option": "currency_decimal_comma",
                "discount_label": discount_label]
    }
}
