//
//  flOffline.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/9/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public struct flOffline {
    public static var isOffline = false {
        didSet {
            flPersistData.setObj(isOffline, forKey: FOURLEAF_OFFLINE)
        }
    }
    
    public static func loadPreviousOffline() {
        isOffline = flPersistData.objForKey(FOURLEAF_OFFLINE) as? Bool ?? false
    }
}

public class flOfflineObjc: NSObject {
    public class var isOffline: Bool { return flOffline.isOffline }
    
    public class func loadPreviousOffline() {
        flOffline.loadPreviousOffline()
    }
}
