//
//  CGRectExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/11/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension CGRect {
    public mutating func setXY(x: CGFloat, y: CGFloat) {
        origin.x = x
        origin.y = y
    }

    public mutating func setWH(width: CGFloat, height: CGFloat) {
        size.width = width
        size.height = height
    }
    
    public mutating func setYH(y: CGFloat, height: CGFloat) {
        origin.y = y
        size.height = height
    }
}
