//
//  NSStringExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/13/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

//MARK: Modify
extension NSString {
    public func applyEmoji() -> NSString {
        var output = self
        
        let maps = ["[clock]": "🕘",
            "[din]": "🍴",
            "[item1]": "🔹"]
        for (key, value) in maps {
            output = output.stringByReplacingOccurrencesOfString(key, withString:value)
        }
        return output
    }
    
    public class func isEmptyString(txt: String?) -> Bool {
        if let uwpTxt = txt {
            if uwpTxt != "" {
                return false
            }
        }
        return true
    }
}
