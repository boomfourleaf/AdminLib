//
//  UIViewExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension UIView {
    public func labelWithTag(tag: Int) -> UILabel? {
        return self.viewWithTag(tag) as? UILabel
    }
    
    public func buttonWithTag(tag: Int) -> UIButton? {
        return self.viewWithTag(tag) as? UIButton
    }
    
    public func textViewWithTag(tag: Int) -> UITextView? {
        return self.viewWithTag(tag) as? UITextView
    }
    
    public func textFieldWithTag(tag: Int) -> UITextField? {
        return self.viewWithTag(tag) as? UITextField
    }
    
    public func imageWithTag(tag: Int) -> UIImageView? {
        return self.viewWithTag(tag) as? UIImageView
    }
    
    public func pickerWithTag(tag: Int) -> UIPickerView? {
        return self.viewWithTag(tag) as? UIPickerView
    }
    
    public func scrollWithTag(tag: Int) -> UIScrollView? {
        return self.viewWithTag(tag) as? UIScrollView
    }
    
    public func cornerRadius(radius: CGFloat=22.0) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
