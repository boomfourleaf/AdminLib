//
//  NSDictionary+Option.swift
//  Dining
//
//  Created by Nattapon Nimakul on 8/19/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

extension NSDictionary {
    public var json: String? {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(self, options: .PrettyPrinted)
            return String(data: jsonData, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            flLog.error("error while converting NSDictionary to json string. \(error.localizedDescription)")
            return nil
        }
    }
}
