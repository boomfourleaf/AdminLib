//
//  flOrderService.swift
//  Dining
//
//  Created by Nattapon Nimakul on 3/5/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public class flOrderService {
    public var orderController: flOrderController?
    public var note = ""
    public var staff: ObjcDictionary?
    public var signatureData: ObjcDictionary?
    public var diningMode: String?
    public var fourleafMode = flMode.Staff
    public var shouldPrintCheck = false
    public var guestAmount = 0
    private let service = flServiceController.sharedService
    
    public init() {
        
    }
    
    public func recordOffline() {
        flRealm.run({ (realm) in
            let order = flOrder.newOrder(realm)
            if let table = self.orderController?.table {
                order.table_zone = table.zone
                order.table_name = table.name
                order.table_split = table.split
            }
            
            let total = flVC.orderController()?.totalPrice() ?? 0
            let subtotal = flVC.orderController()?.totalPriceWithoutServiceChargeAndVat() ?? 0
    //        let serviceCharge = AppsoVC.orderController()?.serviceChargePrice() ?? 0
    //        let vat = AppsoVC.orderController()?.totalPrice() ?? 0
            
            
            order.guest_amount = self.guestAmount
            order.total = "\(total)"
            order.subtotal = "\(subtotal)"
            
    //        order.service_charge =
    //        order.vat
    //        order.misc
            
            try realm.write {
                flOrder.addNewOrder(order, realm: realm)
                
                // Items
                if let items = self.orderController?.list {
                    for item in items {
                        let itemRealm = flOrderItem()
                        itemRealm.id = flOrderItem.newId(realm)
                        
                        itemRealm.name = item.name
                        itemRealm.name_order = item.nameOrder ?? ""
                        itemRealm.name_invoice = item.nameInvoice ?? ""
                        itemRealm.item_id = item.itemId
                        itemRealm.amount = item.amount
                        itemRealm.price = "\(item.price)"
                        itemRealm.final_price = "\(item.final_price)"
                        
                        itemRealm.option = item.option()
                        itemRealm.option_order = item.optionOrder()
                        itemRealm.option_invoice = item.optionInvoice()
                        itemRealm.code = item.code ?? ""
                        //                itemRealm.sensitive = false
                        
                        flLog.info("item \(item.name) \(item.amount)")
                        
                        order.items.append(itemRealm)
                    }
                }
            }
            
        }, success: {
            
            
        }, failed: {
            
        })
    }
    
    public func processOrder() -> flServiceResponse {
        var dict = [String: AnyObject]()
        dict["items"] = orderController?.getListOfDict()
        dict["eat_date"] = ""
        dict["note"] = note
        dict["table"] = orderController?.getTableDict()
        dict["table_name"] = orderController?.table?.display() ?? ""
        dict["signature"] = signatureData
        dict["staff"] = staff ?? ObjcDictionary()
        dict["dining_mode"] = diningMode ?? ""
        dict["staff_mode"] = .Staff == fourleafMode ? NSNumber(bool: true) : NSNumber(bool: false)
        dict["printcheck"] = NSNumber(bool: shouldPrintCheck)
        dict["guest_amount"] = guestAmount
        
//        println("dict \(dict)")
        
        if let plist = service.sendDiningOrder(dict) {
            let plistJson = JSON(plist)
            let responseStatus = plistJson["status"].intValue
            
            // Error
            if responseStatus  != 200 {
//                var action: flActionParser?
//                if let actions = plistJson["actions"].string {
//                    action = flActionParser(actions: actions)
//                }
//                
//                var shouldShowError = true
//                if let actionValue = action {
//                    if actionValue.isAction("show_error", equalToValue: "no") {
//                        shouldShowError = false
//                    }
//                }
//                
//                if shouldShowError {
//                    return .error(error: flApiError.fromData(plist), data:plist, action:action)
                return .error(error: flApiError.fromData(plist), data:plist, action:nil)
//                }
            // Success
            } else {
                return .success(code: responseStatus, data: plist)
            }
        }
        
        let apiError = flApiError.WithMessage(code: flApiError.INTERNET_CONNECTION_ERROR_CODE, title: flApiError.INTERNET_CONNECTION_ERROR_TITLE, description: flApiError.INTERNET_CONNECTION_ERROR_DESCRIPTION)
        return .error(error: apiError, data:nil, action:nil)
    }
}
