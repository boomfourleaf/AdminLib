//
//  UIFontExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/9/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension UIFont {
    public class func flNormalFont(size: CGFloat) -> UIFont {
        if let font = UIFont.init(name: "HelveticaNeue", size: size) {
            return font
        } else {
            return UIFont.systemFontOfSize(size)
        }
    }
    
    public class func flBoldFont(size: CGFloat) -> UIFont {
        if let font = UIFont.init(name: "HelveticaNeue-Bold", size: size) {
            return font
        } else {
            return UIFont.boldSystemFontOfSize(size)
        }
    }
    
    public class func flLightFont(size: CGFloat) -> UIFont {
        if let font = UIFont.init(name: "HelveticaNeue-Light", size: size) {
            return font
        } else {
            return UIFont.systemFontOfSize(size)
        }
    }
}
