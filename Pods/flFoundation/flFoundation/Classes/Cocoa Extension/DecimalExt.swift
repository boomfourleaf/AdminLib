//
//  decimal.swift
//  Dining
//
//  Created by Nattapon Nimakul on 8/24/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

// To declar new overload operator use line below
//infix operator +++++++ {}

let roundUpZeroDecimal = NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundPlain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
let roundUp = NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundPlain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)

extension NSDecimalNumber: Comparable {
    
}

// Fix Equal for subclass of NSObject
extension NSDecimalNumber {
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let right = object as? NSDecimalNumber else {
            return false
        }
        
        let left = self
        
        return NSComparisonResult.OrderedSame == left.compare(right)
    }
}

public func ==(left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return NSComparisonResult.OrderedSame == left.compare(right)
}

public func < (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return NSComparisonResult.OrderedAscending == left.compare(right)
}

/// Duo to incomplete implementation of swift core
/// Manual declar <=, >, >= by our slef
public func <= (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return left < right || left == right
}

public func > (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return right < left
}

public func >= (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return right <= left
}

public func + (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.decimalNumberByAdding(right)
}

public func += (inout left: NSDecimalNumber, right: NSDecimalNumber) {
    left = left + right
}

public func - (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.decimalNumberBySubtracting(right)
}

public func -= (inout left: NSDecimalNumber, right: NSDecimalNumber) {
    left = left - right
}

public func * (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.decimalNumberByMultiplyingBy(right)
}

public func *= (inout left: NSDecimalNumber, right: NSDecimalNumber) {
    left = left * right
}

public func / (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.decimalNumberByDividingBy(right)
}

public func /= (inout left: NSDecimalNumber, right: NSDecimalNumber) {
    left = left / right
}

extension NSDecimalNumber {
    public func fix0() -> NSDecimalNumber {
        return self.decimalNumberByRoundingAccordingToBehavior(roundUpZeroDecimal)
    }

    public func fix2() -> NSDecimalNumber {
        return self.decimalNumberByRoundingAccordingToBehavior(roundUp)
    }
}

public func dec(decString: String) -> NSDecimalNumber {
    return NSDecimalNumber(string: decString)
}

public func dec(decInt: Int) -> NSDecimalNumber {
    return NSDecimalNumber(integer: decInt)
}

public func dec(decDouble: Double) -> NSDecimalNumber {
    return NSDecimalNumber(double: decDouble)
}

public func dec(decFloat: CGFloat) -> NSDecimalNumber {
    return NSDecimalNumber(double: Double(decFloat))
}
