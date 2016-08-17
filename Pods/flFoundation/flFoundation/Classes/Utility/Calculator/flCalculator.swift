//
//  flCalculator.swift
//  Dining
//
//  Created by Nattapon Nimakul on 9/1/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

public enum flCalculatorMode: Int {
    case cash
    case percent
}

public class flCalculator: NSObject {
    public var text: String = ""
    public var supportDecimal: Bool = true
    public var max: NSDecimalNumber?
    public var maxDecimalPosition: Int? = 2
    public weak var vc: UIViewController?
    
    public var mode: flCalculatorMode = .cash {
        willSet(newValue) {
            switch newValue {
            case .cash:
//                supportDecimal = true
//                setNumPadPointText(".")
//                enablePointDecimal()
                max = nil
            case .percent:
                if dec(text) > dec("100") {
                    clear()
                }
//                supportDecimal = false
//                setNumPadPointText("")
//                disablePointDecimal()
                max = dec("100")
            }
        }
    }
    
    public class func newInstance() -> flCalculator {
        return flCalculator()
    }

//    init() {
//        
//    }
    
    public func enterCashMode() {
        mode = .cash
    }
    
    public func enterPercentMode() {
        mode = .percent
    }
    
    public func getMode() -> String {
        switch mode {
        case .cash:
            return "cash"
        case .percent:
            return "percent"
        }
    }
    
    public class func decimalPosition(text: String) -> Int {
        if let location = text.locationOf(".")  {
            return text.characters.count - 1 - location
        }
        
        return 0
    }

    public func addUnit(chr: String) {
        // Prevent add . for non support decimal mode
        if !supportDecimal && "." == chr {
            return
        }
        
        // Don't add more . for last one is .
        if "." == chr && text.hasAny(".") {

        } else {
            // Check for maximum number
            if nil != max && dec(text+chr) > max {
                return
            }
            // Check for maximum decimal position
            if nil != maxDecimalPosition && flCalculator.decimalPosition(text+chr) > maxDecimalPosition {
                return
            }
            
            text += chr
        }
    }
    
    public func removeUnit() {
        if text.characters.count > 0 {
            // Remove . and last digit together when last string is Dot
            if text.lastCharactor() == "."
                && text.characters.count >= 2 {
                text = text.substringToIndex(text.startIndex.advancedBy(text.characters.count - 2))
            } else {
                text = text.substringToIndex(text.startIndex.advancedBy(text.characters.count - 1))
            }
        }
    }

    public var decimal: NSDecimalNumber {
        get { return "" == text ? dec("0") : dec(text) }
        set {
            clear()
            for charString in newValue.stringValue.characters {
                addUnit(String(charString))
            }
        }
    }
    
    public var string: String {
        get { return text }
        set {
            clear()
            for charString in newValue.characters {
                addUnit(String(charString))
            }
        }
    }
    
    public func clear() {
        text = ""
    }

    public class func initNumpad(target: AnyObject, view: UIView, forAction selector: Selector) {
        for tag in 700..<712 {
            if let button = view.viewWithTag(tag) as? UIButton {
                button.addTarget(target, action: selector, forControlEvents:.TouchUpInside)
            }
        }
    }
    
    public class func initNumpadHilight(view: UIView) {
        for tag in 700..<712 {
            if let button = view.viewWithTag(tag) as? UIButton {
                button.setBackgroundImage(UIImage(named: "numPadSelected.png"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    public func processNumpadForTag(numTag: NSNumber) {
        let tag = numTag.integerValue
        if 700 <= tag && tag <= 709 {
            addUnit("\(tag-700)")
            
        } else if 710 == tag {
            addUnit(".")

        } else if 711 == tag {
            removeUnit()
        }
    }
    
    public func pointDecimalButton() -> UIButton? {
        return vc?.view.viewWithTag(710) as? UIButton
    }
    
    public func setNumPadPointText(text: String) {
        pointDecimalButton()?.setTitle(text, forState: UIControlState.Normal)
    }
    
    public func disablePointDecimal() {
        pointDecimalButton()?.enabled = false
    }
    
    public func enablePointDecimal() {
        pointDecimalButton()?.enabled = true
    }
}
