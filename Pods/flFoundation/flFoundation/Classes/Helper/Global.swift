//
//  global.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/10/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

public typealias ObjcDictionary = [NSObject: AnyObject]

//MARK: Main Thread
public func main(closure:()->()) {
    dispatch_async(dispatch_get_main_queue(), closure)
}

public func main(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

public func mainSync(closure:()->()) {
    dispatch_sync(dispatch_get_main_queue(), closure)
}

//MARK: Background Thread
public func background(closure:()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), closure)
}

public func background(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), closure)
}

public func backgroundSync(closure:()->()) {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), closure)
}














//MAKR: Helper
public func runAsyncClosure(closure:dispatch_block_t, onQueue queue: dispatch_queue_t) {
    dispatch_async(queue, closure)
}

public func runSyncClosure(closure:dispatch_block_t, onQueue queue: dispatch_queue_t) {
    dispatch_sync(queue, closure)
}

public func runClosure(closure:dispatch_block_t, onQueue queue: dispatch_queue_t, afterDelay delay: Double) {
    let delayTime = dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, queue, closure)
}

// Prioprity Order
// Main Thread
// Background High Priority
// Background Default Priority
// Background Low Priority
// Background

//MARK: Background High Priority
public func runInHighPriority(closure:dispatch_block_t) {
    runAsyncClosure(closure, onQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
}

public func runInHighPriorityWithDelay(delay:Double, closure:dispatch_block_t) {
    runClosure(closure, onQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), afterDelay: delay)
}

public func runInHighPrioritySync(closure:dispatch_block_t) {
    runSyncClosure(closure, onQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
}

//MARK: Log
public func trackOpen(type: String, name: String) {
//    PFAnalytics.trackEventInBackground("open", dimensions: ["customer": flServerConfigure.shareObject.customerName, "type": type, "name": name]) { _ in }
}

// Enum
public enum Hilight: CustomStringConvertible {
    case Normal, Red
    
    public var description: String {
        switch self {
            case .Normal: return "normal"
            case .Red: return "red"
        }
    }
}

// Swift equivalent to Objective-C's “@synchronized”
public func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

public var LANGUAGE_CHANGE_NOTIFY: String { return "LANGUAGE_CHANGE_NOTIFY" }
public var isOffline: Bool { return flOffline.isOffline }
public var VERSION_NUMBER: String { return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String ?? "" }
public var BUILD_NUMBER: String { return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String ?? "" }
public var VERSION_DATE: String { return "2016-05-17" }
public var VERSION_NUMBER_WITH_DATE: String { return VERSION_NUMBER + " " + VERSION_DATE }
