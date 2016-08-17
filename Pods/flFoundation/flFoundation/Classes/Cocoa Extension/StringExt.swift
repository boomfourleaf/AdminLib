//
//  string.swift
//  Dining
//
//  Created by Nattapon Nimakul on 9/1/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

//MARK: - Initializer
extension String {
    public init(orEmpty any: AnyObject?) {
        if let txt = any as? String {
            self = txt
        } else {
            self = ""
        }
    }
}

//MARK: - Subscription
extension String {
    public subscript(index: Int) -> String? {
        get {
            return hasIndex(index) ? String(self[startIndex.advancedBy(index)]): nil
        }
        set {
            if hasIndex(index) {
                if let value = newValue {
                    replaceRange(startIndex.advancedBy(index)...startIndex.advancedBy(index), with: value)
                }
            }
        }
    }

    // Python range style
    public subscript(range: Range<Int>) -> String? {
        get {
            switch (hasIndex(range.startIndex), hasIndex(range.endIndex-1)) {
            case (true, true):
                return self[stringRange(range)]
            case (true, false): // substring till end (python style)
                return self[startIndex.advancedBy(range.startIndex)..<endIndex]
            default:
                return nil
            }
        }
        set {
            if let value = newValue {
                switch (hasIndex(range.startIndex), hasIndex(range.endIndex-1)) {
                case (true, true):
                    replaceRange(stringRange(range), with: value)
                case (true, false): // substring till end (python style)
                    replaceRange(startIndex.advancedBy(range.startIndex)..<endIndex, with: value)
                default:
                    break
                }
            }
        }
    }
}

//MARK: - Check, Search
extension String {
    public func hasAny(find: String) -> Bool {
        return nil != locationOf(find) ? true : false
    }
    
    public func locationOf(str: String) -> Int? {
        if let range = rangeOfString(str) {
            return startIndex.distanceTo(range.startIndex)
        } else {
            return nil
        }
    }
}

//MARK: - Get
extension String {
    public func firstCharactor() -> String? {
        if self.characters.count > 0 {
            return self[0]
        }
        return nil
    }
    
    public func lastCharactor() -> String? {
        if self.characters.count > 0 {
            return self[self.characters.count - 1]
        }
        return nil
    }
    
    public func toCGFloat() -> CGFloat? {
        if let number = NSNumberFormatter().numberFromString(self) {
            return CGFloat(number)
        } else {
            return nil
        }
    }
}

// Private
extension String {
    private func stringRange(range: Range<Int>) -> Range<String.Index> {
        return startIndex.advancedBy(range.startIndex)..<startIndex.advancedBy(range.endIndex)
    }
    
    private func hasIndex(index: Int) -> Bool {
        return index >= 0 && index < self.characters.count
    }
}

