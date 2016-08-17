//
//  Recorder.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/5/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public protocol RecorderType {
    associatedtype Element
    var count: Int { get }
    
    /// Set new value or nil to remove
    subscript(key: String) -> Element? { set get }
    
    mutating func clear()
}

extension RecorderType where Element: IntegerType {
    public mutating func adjust(key: String, quantity: Element) {
        if let oldValue = self[key] {
            self[key] = oldValue + quantity
        }
    }
}

public struct Recorder<T>: RecorderType {
    private var records = [String: T]()
    public var count: Int { return records.count }
    
    /// Set new value or nil to remove
    public subscript(key: String) -> T? {
        get {
            return records[key]
        }
        set {
            if let newQuantity = newValue {
                records[key] = newQuantity
            } else {
                records.removeValueForKey(key)
            }
        }
    }
    
    public mutating func clear() {
        records.removeAll()
    }
    
    public init() {
        
    }
}
