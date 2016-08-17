//
//  flLiveData.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/6/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public class flLiveData {
    static let lock = NSObject()
    static let sharedService = flLiveData()
    
    lazy var dict = ObjcDictionary()
    
    public static func setObj(obj: AnyObject?, forKey key: NSObject) {
        synced(lock) {
            if let objValue = obj {
                sharedService.dict[key] = objValue
            } else {
                sharedService.dict.removeValueForKey(key)
            }
        }
    }
    
    public static func objForKey(key: NSObject) -> AnyObject? {
        var output: AnyObject?
        synced(lock) {
            output = sharedService.dict[key]
        }
        return output
    }
    
    public static func clrForKey(key: NSObject) {
        synced(lock) {
            sharedService.dict.removeValueForKey(key)
        }

    }
}
