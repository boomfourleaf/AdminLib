//
//  SwiftyJSONExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/26/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    //MARK: [String : AnyObject]
    public var dictionaryObjectValue: [String : AnyObject] {
        return dictionaryObject ?? [:]
    }
    
    //MARK: Date
    public func dateForKey(key: String) -> NSDate? {
        return dictionaryObjectValue[key] as? NSDate
    }
    
    public func dateValueForKey(key: String) -> NSDate {
        return dateForKey(key) ?? NSDate()
    }
    
    //MARK: CGFloat
    public var cgFloat: CGFloat? {
        return (number?.floatValue).flatMap { CGFloat($0) }
    }
    
    public var cgFloatValue: CGFloat {
        return CGFloat(numberValue.floatValue)
    }

    //MARK: Decimal
    public var decimal: NSDecimalNumber? {
        if let numberValue = number {
            return NSDecimalNumber(decimal: numberValue.decimalValue)
        } else {
            return nil
        }
    }
    
    public var decimalValue: NSDecimalNumber {
        return decimal ?? NSDecimalNumber(integer: 0)
    }

}
