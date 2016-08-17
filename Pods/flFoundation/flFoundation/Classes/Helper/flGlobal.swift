//
//  flGlobal.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/6/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public enum flMode: Int {
    case No,          // No mode assigned
    Staff,       // Staff mode for make order and manage
    Guest       // Only make order and see their history
}

public struct flGlobal {
    //MARK: Mode
    private static var _modeLock = NSObject()
    private static var _mode: flMode = .No
    public static func setMode(mode: flMode) {
        synced(flGlobal._modeLock) {
            flGlobal._mode = mode
        }
    }
    
    public static func mode() -> flMode {
        var output: flMode!
        synced(flGlobal._modeLock) {
            output = flGlobal._mode
        }

        return output
    }
    
    //MARK: Staff
    private static var _staffLock = NSObject()
    private static var _staff: [NSObject: AnyObject]?
    public static func setStaff(staff: [NSObject: AnyObject]) {
        synced(flGlobal._staffLock) {
            flGlobal._staff = staff
        }
    }
    
    public static func staff() -> [NSObject: AnyObject]? {
        var output: [NSObject: AnyObject]?
        synced(flGlobal._staffLock) {
            output = flGlobal._staff
        }
        
        return output
    }
    
    public static func clearStaff() {
        synced(flGlobal._staffLock) {
            flGlobal._staff = nil
        }
    }
    
    //MARK: Invoice
    private static var _invoiceLock = NSObject()
    private static var _invoice: [NSObject: AnyObject]?
    public static func setInvoiceConfigure(dict: [NSObject: AnyObject]) {
        synced(flGlobal._invoiceLock) {
            flGlobal._invoice = dict
        }
    }
    
    public static func invoiceConfigure() -> [NSObject: AnyObject]? {
        var output: [NSObject: AnyObject]?
        synced(flGlobal._invoiceLock) {
            output = flGlobal._invoice
        }
        
        return output
    }
}

