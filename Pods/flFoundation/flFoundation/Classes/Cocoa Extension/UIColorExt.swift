//
//  UIColorExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/6/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hex: UInt) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }

    public convenience init(rgba: (r: Int, g: Int, b: Int, a: CGFloat)) {
        let max = CGFloat(256.0)
        self.init(red: CGFloat(rgba.r)/max, green: CGFloat(rgba.g)/max, blue: CGFloat(rgba.b)/max, alpha: rgba.a)
    }
    
    public convenience init(rgb: (r: Int, g: Int, b: Int)) {
        self.init(rgba: (rgb.r, rgb.g, rgb.b, CGFloat(1.0)))
    }
}


//MARK: Color Presets
extension UIColor {
    public class func alertRed() -> UIColor { return UIColor(rgb: (218, 41, 16)) }
}
