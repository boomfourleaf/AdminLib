//
//  UIView+Option.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/27/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

extension UIView {
    public func imageThisView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 2.0)
        if let currentContext = UIGraphicsGetCurrentContext() {
            layer.renderInContext(currentContext)
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
}
