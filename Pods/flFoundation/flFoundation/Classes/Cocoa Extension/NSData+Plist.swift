//
//  NSData+Plist.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/7/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation
import SwiftyJSON

extension NSData {
    public var plist: JSON? {
        do {
            let propertyList = try NSPropertyListSerialization.propertyListWithData(self, options: .Immutable, format: nil)
            return JSON(propertyList)
        } catch {
            return nil
        }
    }
    
    public var json: JSON? {
        if let data = SBJsonParser().objectWithData(self) {
            return JSON(data)
        } else {
            return nil
        }
    }
}
