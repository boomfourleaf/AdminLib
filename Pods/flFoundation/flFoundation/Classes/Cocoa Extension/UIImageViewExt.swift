//
//  UIImageExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/19/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

extension UIImageView {
    public func showAndUpdateWidthContraint(widthConstraint: NSLayoutConstraint!) {
        hidden = false
        if let width = image?.size.width {
            widthConstraint.constant = width
        }
    }
    
    public func hideAndUpdateWidthContraint(widthConstraint: NSLayoutConstraint!) {
        hidden = true
        widthConstraint.constant = 0.0
    }
}
