//
//  flVersionController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/1/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public struct flVersionController {
    public static func isVerionChanged() -> Bool {
        if let versionHaveChange = flPersistData.objForKey(Config.FOURLEAF_VERSION_HAVE_CHANGE_KEY) as? String
            where versionHaveChange == "YES" {
            return true
        } else {
            return false
        }
    }
    
    public static func checkIfVersionChanged() {
        let thisVersion = VERSION_NUMBER
        var markAsNewVersion = false
        
        // If hvae previous version set
        if let previousVersion = flPersistData.objForKey(Config.FOURLEAF_VERSION_KEY) as? String
            where previousVersion != "" {
            
            // New version
            if previousVersion != thisVersion {
                markAsNewVersion = true
                flLog.info("new version deteched")
            }
            
            // Don't have previous version
        } else {
            markAsNewVersion = true
            flLog.info("don't have previous version, then new version deteched")
        }
        
        if markAsNewVersion {
            flPersistData.setObj("YES", forKey:Config.FOURLEAF_VERSION_HAVE_CHANGE_KEY)
            flPersistData.setObj(thisVersion, forKey:Config.FOURLEAF_VERSION_KEY)
        }
    }
    
    public static func markAsContentIsUpToDate() {
        flPersistData.setObj(nil, forKey:Config.FOURLEAF_VERSION_HAVE_CHANGE_KEY)
    }
}

extension flVersionController {
    struct Config {
        static let FOURLEAF_VERSION_KEY = "FOURLEAF_VERSION"
        static let FOURLEAF_VERSION_HAVE_CHANGE_KEY = "FOURLEAF_VERSION_HAVE_CHANGE"
    }
}
