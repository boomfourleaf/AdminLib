//
//  flDiscountFilterController.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/6/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

public struct DiscountFilter {
    public var name: String
    public var id: Int
    public var on: Bool
    
    public init(name: String, id: Int, on: Bool) {
        self.name = name
        self.id = id
        self.on = on
    }
}

public class DiscountFilterController: NSObject {
    public var filters: [DiscountFilter]?
    
    public class var defaultFilters: [DiscountFilter]? {
        get {
            return DiscountFilterDefaultLiveStorage.sharedController.filters
        }
        set {
            DiscountFilterDefaultLiveStorage.sharedController.filters = newValue
        }
    }
    
    public override init() {
        super.init()
        filters = DiscountFilterController.defaultFilters
    }
    
    public func selectedFilters() -> [DiscountFilter]? {
        return filters?.filter{ (filter) in filter.on }
    }
}

private class DiscountFilterDefaultLiveStorage {
    var filters: [DiscountFilter]?
    
    class var sharedController: DiscountFilterDefaultLiveStorage {
        // Duo to no class variable support, then this's a work around singleton version
        struct Static {
            static let instance = DiscountFilterDefaultLiveStorage()
        }
        return Static.instance
    }
}
