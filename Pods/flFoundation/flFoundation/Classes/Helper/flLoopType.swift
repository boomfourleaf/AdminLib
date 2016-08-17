//
//  flLoopType.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/13/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public struct flLoopType<T>: CollectionType {
    public let startIndex: Int
    public let endIndex: Int
    public let subscription: (Int) -> T
    
    public subscript(index: Int) -> T {
        return subscription(index)
    }
    
    public init(startIndex: Int, endIndex: Int, subscription: (Int) -> T) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.subscription = subscription
    }
}
