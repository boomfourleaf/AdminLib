//
//  flCalculatorCreditCard.swift
//  Dining
//
//  Created by Nattapon Nimakul on 10/19/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

public class flCalculatorCreditCard: flCalculator {
    
    public override class func newInstance() -> flCalculatorCreditCard {
        return flCalculatorCreditCard()
    }
    
    public override init() {
        super.init()
        // perform some initialization here
        supportDecimal = false
        max = dec("9999999999999999") // 16 Digits
    }
    
    public func display() -> String {
        if text == "" {
            return "_"
        }
        
        // Convert to 1234-5678-1234-5678 format
        if text.characters.count >= 13 {
            return text[0...3]! + "-" + text[4...7]! + "-" + text[8...11]! + "-" + text[12...(text.characters.count - 1)]!
            
        } else if text.characters.count >= 9 {
            return text[0...3]! + "-" + text[4...7]! + "-" + text[8...(text.characters.count - 1)]!
            
        } else if text.characters.count >= 5 {
            return text[0...3]! + "-" + text[4...(text.characters.count - 1)]!
            
        }
        
        return text
    }
}
