//
//  flOrderController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 3/9/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK: Order Controller
public class flOrderController {
    public lazy var list = [flOrderItemObj]()
    public var serviceCharge: CGFloat = 0
    public var vat: CGFloat = 0
    public var vat_mode = FOURLEAF_VAT_MODE_INCLUDED
    public var serviceCharge_mode = SERVCIE_CHARGE_MODE_INCLUDED
    public var orderLangSuffix: String?
    public var invoiceLangSuffix: String?
    public var manual_remark_grand_total: String?
    public var signature = false
    public var auto_logout = false

    public var orderConfig: ObjcDictionary? {
        didSet {
            if let orderConfigValue = orderConfig {
                let orderConfigJson = JSON(orderConfigValue)
                serviceCharge = CGFloat(orderConfigJson["service_charge"].floatValue)
                vat = CGFloat(orderConfigJson["vat"].floatValue)
                vat_mode = orderConfigJson["vat_mode"].stringValue
                serviceCharge_mode = orderConfigJson["service_charge_mode"].stringValue
                orderLangSuffix = orderConfigJson["order_language"].stringValue
                invoiceLangSuffix = orderConfigJson["invoice_language"].stringValue
                manual_remark_grand_total = orderConfigJson["manual_remark_grand_total"].stringValue
                if let signature = orderConfigJson["signature"].bool {
                    self.signature = signature
                }
                if let auto_logout = orderConfigJson["auto_logout"].bool {
                    self.auto_logout = auto_logout
                }
            }
        }
    }
    public var table: flTableObj?
    
    public init() {
        
    }
}

//MARK: Public API
extension flOrderController {
    public func add(item: flOrderItemObj) -> Bool {
        
        // + 1 if item is exist
        if let index = list.indexOf( item.isEqualByIgnoringQuantity ) {
            list[index].amount += 1
            return true
        }

        // insert new if item isn't exist
        list.append(item)
        return true
    }
    
    public func clear() -> Bool {
        list.removeAll(keepCapacity: false)
        table = nil
        return true
    }
    
    public func clearItems() -> Bool {
        list.removeAll(keepCapacity: false)
        return true
    }
    
    public func getObject(itemId: String?) -> flOrderItemObj? {
        for eachItem in list {
            if eachItem.itemId == itemId {
                return eachItem
            }
        }
        return nil
    }
    
    public func getObjects(itemId: String?) -> [flOrderItemObj] {
        return list.filter { $0.itemId == itemId }
    }
    
    public func itemCount() -> Int {
        return list.count
    }
    
    public func itemCountWithAmount() -> Int {
        return list.reduce(0, combine: { $0 + $1.amount })
    }
    
    public func serviceChargePrice() -> CGFloat {
        if SERVCIE_CHARGE_MODE_INCLUDED == serviceCharge_mode {
            return 0
        } else {
            let total = totalPriceWithoutServiceChargeAndVat()
            return flOrderController.serviceChargeCal(serviceCharge, total: total)
        }
    }
    
    public func totalPriceWithoutServiceChargeAndVat() -> CGFloat {
        return list.reduce(CGFloat(0), combine: { sum, item in
            sum + (item.final_price + item.option_price) * CGFloat(item.amount)
        })
    }
    
    func totalPriceWithServiceCharge() -> CGFloat {
        let total = totalPriceWithoutServiceChargeAndVat()
        let totalAndService = total + serviceChargePrice()
        return totalAndService
    }
    
    public func totalPrice() -> CGFloat {
        switch vat_mode {
        case FOURLEAF_VAT_MODE_INCLUDED:
            let totalAndService = totalPriceWithServiceCharge()
            return totalAndService
            
        case FOURLEAF_VAT_MODE_EXCLUDED:
            let totalAndService = totalPriceWithServiceCharge()
            let grandTotal = totalAndService + flOrderController.vatCal(vat, total:totalAndService)
            return grandTotal
        default: return 0
        }
    }
    
    public func grandeTotalRemark() -> String {
        if let manual_remark_grand_totalValue = manual_remark_grand_total {
            return manual_remark_grand_totalValue
        }

        if 0 != vat {
            return NSString(format: "(Inc. Vat %.0f%%)", vat) as String
        }
        
        return ""
    }
    
    // Convert array of object => array of dictionary
    public func getListOfDict() -> [ObjcDictionary] {
        var outList = [ObjcDictionary]()
        for eachItem in list {
            var dict = ObjcDictionary()
            dict["name"] = eachItem.name
            dict["name_display"] = eachItem.displayName
            dict["name_order"] = eachItem.nameOrder
            dict["name_invoice"] = eachItem.nameInvoice
            dict["price"] = eachItem.price
            dict["final_price"] = eachItem.final_price
            dict["option_price"] = eachItem.option_price
            dict["itemId"] = eachItem.itemId
            dict["metaTag"] = eachItem.metaTag
            dict["amount"] = eachItem.amount
            dict["options"] = eachItem.optionList()
            if let code = eachItem.code {
                dict["code"] = code
            }
            outList.append(dict)
        }
        return outList
    }
    
    public func getListOfDictForHistoryPage() -> [ObjcDictionary] {
        var outList = [ObjcDictionary]()
        for eachItem in list {
            var dict = ObjcDictionary()
            dict["name"] = eachItem.name
            dict["name_display"] = eachItem.displayName
            dict["name_order"] = eachItem.nameOrder
            dict["name_invoice"] = eachItem.nameInvoice
            dict["amount"] = eachItem.amount
            dict["price"] = eachItem.final_price + eachItem.option_price
            dict["price_option"] = "currency_baht_sign_and_two_decimal"
            dict["option"] = eachItem.option()
            dict["option_display"] = eachItem.displayOption()
            dict["options"] = eachItem.optionList()
            if let code = eachItem.code {
                dict["code"] = code
            }
            outList.append(dict)
        }
        return outList
    }
    
    // Create Table Data Dict
    public func getTableDict() -> ObjcDictionary {
        if let tableValue = table {
            return tableValue.dict()
        }
        return [:]
    }
}

//MARK: Public
extension flOrderController {
    private class func percentCal(percent: CGFloat, total: CGFloat) -> CGFloat {
        return total * percent / 100
    }
    
    private class func serviceChargeCal(serviceCharge: CGFloat, total: CGFloat) -> CGFloat {
        return flOrderController.percentCal(serviceCharge, total:total)
    }
    
    private class func vatCal(vat: CGFloat, total: CGFloat) -> CGFloat {
        return flOrderController.percentCal(vat, total:total)
    }
}
