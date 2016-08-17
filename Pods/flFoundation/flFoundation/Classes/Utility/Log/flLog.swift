//
//  flLog.swift
//  Dining
//
//  Created by Nattapon Nimakul on 8/24/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

final public class FOURLEAFCoreLog {
    public var printDebugTask: ((String) -> Void)?
    public var printInfoTask: ((String) -> Void)?
    public var printWarningTask: ((String) -> Void)?
    public var printErrorTask: ((String) -> Void)?
    
    public static var shareService: FOURLEAFCoreLog {
        let obj = FOURLEAFCoreLog()
        obj.printDebugTask = { text in
            NSLog(text)
        }
        
        obj.printInfoTask = { text in
            NSLog(text)
        }
        
        obj.printWarningTask = { text in
            NSLog(text)
        }
        
        obj.printErrorTask = { text in
            NSLog(text)
        }
        
        return obj
    }
}

public struct flLog {
    public static func debug(text: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        let paths = file.componentsSeparatedByString("/")
        if let thisFile = paths.last {
            let fileName = thisFile.subString(0, end:thisFile.characters.count - 6)
            FOURLEAFCoreLog.shareService.printDebugTask?("[debug]\(fileName).\(function):\(line) \(text)")
        }
    }
    
    public static func info(text: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        let paths = file.componentsSeparatedByString("/")
        if let thisFile = paths.last {
            let fileName = thisFile.subString(0, end:thisFile.characters.count - 6)
            FOURLEAFCoreLog.shareService.printInfoTask?("[info]\(fileName).\(function):\(line) \(text)")
        }
    }
    
    public static func warn(text: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        let paths = file.componentsSeparatedByString("/")
        if let thisFile = paths.last {
            let fileName = thisFile.subString(0, end:thisFile.characters.count - 6)
            FOURLEAFCoreLog.shareService.printWarningTask?("[warning]\(fileName).\(function):\(line) \(text)")
        }
    }
    
    public static func error(text: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        let paths = file.componentsSeparatedByString("/")
        if let thisFile = paths.last {
            let fileName = thisFile.subString(0, end:thisFile.characters.count - 6)
            FOURLEAFCoreLog.shareService.printErrorTask?("[error]\(fileName).\(function):\(line) \(text)")
        }
    }
}

public class flLogObjc: NSObject {
    public static func debug(text: String) {
        flLog.debug(text)
    }
    
    public static func info(text: String) {
        flLog.info(text)
    }
    
    public static func warn(text: String) {
        flLog.warn(text)
    }
    
    public static func error(text: String) {
        flLog.error(text)
    }
}
