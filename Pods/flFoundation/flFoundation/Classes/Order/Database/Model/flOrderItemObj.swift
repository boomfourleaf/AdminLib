//
//  flOrderItemObj.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/23/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

// Order
private var ORDER_OPTION            : String { return "options" }
private var ORDER_OPTION_DISPLAY    : String { return "option_display" }
private var ORDER_OPTION_ORDER      : String { return "option_order" }
private var ORDER_OPTION_INVOICE    : String { return "option_invoice" }
private var ORDER_PROMOTION         : String { return "promotions" }

//MARK: Order Item Object
public struct flOrderItemObj {
    public var name = ""
    public var price: CGFloat = 0
    public var final_price: CGFloat = 0
    public var final_price_display_style: String?
    public var option_price: CGFloat = 0
    public var itemId: String = ""
    public var amount = 0
    
    public var metaTag = [String: String]()
    private var options = [flOrderItemOptionObj]()
    public var displayName: String?
    public var nameOrder: String?
    public var nameInvoice: String?
    public var code: String?
    
    public var final_priceDisplay: String { return localize(["price": final_price, "price_option": final_price_display_style ?? ""], key: "price") }
    
    public init() {
        
    }
    
    private mutating func setOption(optionText: String, withKey key: String) {
        metaTag[key] = optionText
    }
    
    public mutating func setOption(optionText: String?) {
        if let optionTextValue = optionText {
            setOption(optionTextValue, withKey: ORDER_OPTION)
        }
    }
    
    public mutating func setDisplayOption(optionText: String?) {
        if let optionTextValue = optionText {
            setOption(optionTextValue, withKey: ORDER_OPTION_DISPLAY)
        }
    }
    
    public mutating func setOptionOrder(optionText: String?) {
        if let optionTextValue = optionText {
            setOption(optionTextValue, withKey: ORDER_OPTION_ORDER)
        }
    }
    
    public mutating func setOptionInvoice(optionText: String?) {
        if let optionTextValue = optionText {
            setOption(optionTextValue, withKey: ORDER_OPTION_INVOICE)
        }
    }
    
    public mutating func addOptionWithId(id: String, title: String, amount: NSDecimalNumber) {
        options.append( flOrderItemOptionObj(id: id, title: title, amount: amount) )
    }
    
    func optionList() -> [ObjcDictionary] {
        return options.map { $0.dictionary() }
    }
    
    public mutating func setPromotion(promoText: String?) {
        if let promoTextValue = promoText {
            setOption(promoTextValue, withKey: ORDER_PROMOTION)
        }
    }
    
    private func optionWithKey(key: String) -> String {
        if let optionText = metaTag[key] {
            return optionText
        }
        
        return ""
    }
    
    public func option() -> String {
        return optionWithKey(ORDER_OPTION)
    }
    
    public func displayOption() -> String {
        return optionWithKey(ORDER_OPTION_DISPLAY)
    }
    
    public func optionOrder() -> String {
        return optionWithKey(ORDER_OPTION_ORDER)
    }
    
    public func optionInvoice() -> String {
        return optionWithKey(ORDER_OPTION_INVOICE)
    }
    
    public func promotion() -> String {
        return optionWithKey(ORDER_PROMOTION)
    }
    
    private func allMetas(orderOptionKey: String) -> String {
        var arr = [String]()
        if let promoText = metaTag[ORDER_PROMOTION] {
            arr.append(promoText)
        }
        if let optionText = metaTag[orderOptionKey] {
            arr.append(optionText)
        }
        
        return arr.reduce("", combine: { $0 + "\n" + $1 })
    }
    
    public func allMetas() -> String {
        return allMetas(ORDER_OPTION)
    }
    
    public func allDisplayMetas() -> String {
        return allMetas(ORDER_OPTION_DISPLAY)
    }
}

extension flOrderItemObj: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        var output = ""
        output += "name: \(name)"
        output += "    displayName: \(displayName)"
        output += "    nameOrder: \(nameOrder)"
        output += "    nameInvoice: \(nameInvoice)"
        output += "    price: \(price)"
        output += "    final price: \(final_price)"
        output += "    option price: \(option_price)"
        output += "    itemId: \(itemId)"
        output += "    metaTag: \(metaTag)"
        output += "    amount: \(amount)"
        output += "    code: \(code)"
        return output
    }
    
    public var debugDescription: String {
        return description
    }
}



// Equal without amount
extension flOrderItemObj {
    public func isEqualByIgnoringQuantity(rhs: flOrderItemObj) -> Bool {
        let lhs = self
        
        if lhs.name != rhs.name {
            return false
        }
        
        if lhs.displayName != rhs.displayName {
            return false
        }
        
        if lhs.nameOrder != rhs.nameOrder {
            return false
        }
        
        if lhs.nameInvoice != rhs.nameInvoice {
            return false
        }
        
        if lhs.price != rhs.price {
            return false
        }
        
        if lhs.final_price != rhs.final_price {
            return false
        }
        
        if lhs.option_price != rhs.option_price {
            return false
        }
        
        if lhs.itemId != rhs.itemId {
            return false
        }
        
        if lhs.metaTag != rhs.metaTag {
            return false
        }
        
        if lhs.code != rhs.code {
            return false
        }
        
        return true
    }
}
