//
//  NSURLExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/28/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension NSURL {
    public convenience init?(fileURLWithName fileName: String) {
        let imagePath = (NSBundle.mainBundle().resourcePath as NSString?)?.stringByAppendingPathComponent(fileName)
        self.init(fileURLWithPath: imagePath ?? "")
    }
}
