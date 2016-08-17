//
//  flTableObj.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/23/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public struct flTableObj {
    public var zone = ""
    public var name = ""
    public var split = 0
    
    public init(zone: String, name: String, split: Int) {
        self.zone = zone
        self.name = name
        self.split = split
    }
    
    public init(text: String) {
        self.zone = text
    }
    
    private func _display(withSplit withSplit: Bool) -> String {
        var tableName = zone
        if name != "" {
            tableName += " " + name
        }
        
        if withSplit && 0 != split {
            tableName += " / \(split)"
        }
        
        return tableName
    }
    
    public func display() -> String {
        return _display(withSplit: true)
    }
    
    public func displayWithoutSplit() -> String {
        return _display(withSplit: false)
    }
    
    public func dict() -> ObjcDictionary {
        return ["zone": zone, "name": name, "split": split]
    }
}

