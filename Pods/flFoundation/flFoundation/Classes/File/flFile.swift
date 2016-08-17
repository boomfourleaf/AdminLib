//
//  flFile.swift
//  Dining
//
//  Created by Nattapon Nimakul on 4/27/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

@objc final class flFile: NSObject {
    class func mainDocument() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
    }
    
    private class func pathFor(filePackage: flFilePackage) -> String {
        return (flFile.mainDocument() as NSString).stringByAppendingPathComponent(filePackage.path)
    }
    
    class func absolutePathFor(filePackage: flFilePackage, fileName name: String) -> String {
        return (flFile.pathFor(filePackage) as NSString).stringByAppendingPathComponent(name)
    }
}

//MARK: File Handeling
extension flFile {
    class func isExist(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(path)
    }
    
    private class func deleteFileAtPath(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(path)
        } catch let errorValue as NSError {
            flLog.error("error \(errorValue.localizedDescription) path:\(path)")
            return false
        }
        return true
    }
    
    class func deleteIfExist(path: String) -> Bool {
        if isExist(path) {
            return deleteFileAtPath(path)
        }
        return false
    }
}

@objc enum flFilePackage: Int {
    case IMAGE,
        MYROOM_INFO,
        MESSAGE,
        FEED_BACK,
        ORDER_HISTORY,
        ACTIVITY_CATEGORY,
        SPECIAL_CATEGORY,
        GALLERY_CATEGORY,
        FIRST_AID_CATEGORY,
        HOTEL_INFO,
        DINING,
        WEATHER,
        MAP,
        NEWS,
        SPA,
        MYROOM_PROFILE,
        HONEYMOON,
        HOUSE_KEEPING,
        SETTING,
        LANGUAGE

    var path: String {
        get {
            switch self {
                case .IMAGE: return flFile.Config.IMAGE_PATH
                default: return flFile.Config.BASE_PATH
            }
        }
    }
}

//MARK: Config
extension flFile {
    private struct Config {
        // File Path
        static let BASE_PATH = "Appso/Data"
        static let IMAGE_PATH = "Appso/Image"
    }
}
