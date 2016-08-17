//
//  flPersistData.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/6/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public struct flPersistData {
    public static func setObj(obj: AnyObject?, forKey key: String) {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        
        synced(standardUserDefaults) {
            if let objValue = obj {
                standardUserDefaults.setObject(objValue, forKey:key)
            } else {
                standardUserDefaults.removeObjectForKey(key)
            }
            standardUserDefaults.synchronize()
        }
    }
    
    public static func objForKey(key: String) -> AnyObject? {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var val: AnyObject?
        synced(standardUserDefaults) {
            val = standardUserDefaults.objectForKey(key)
        }
        
        return val
    }
}
