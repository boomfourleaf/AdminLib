//
//  UIBarButtonItemExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 2/5/2558 BE.
//  Copyright (c) 2558 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    public convenience init(SpacerWidth space: CGFloat) {
        self.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        self.width = space
    }
    
    public convenience init(languageBarButtonItemWithTitle title: String?, target: AnyObject?, action: Selector) {
        self.init(title:title, style:.Plain, target:target, action:action)
    }
    
    public func setHumanEyeFont() {
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = UIFont.flBoldFont(23.0)
        setTitleTextAttributes(attributes, forState: .Normal)
    }
    
    public func setFontToNormal() {
        setTitleTextAttributes(nil, forState: .Normal)
    }
}

extension UIBarButtonItem {
    public convenience init(buttonWithTitle title: String, font: UIFont = .flBoldFont(23.0), fontColor: UIColor = .whiteColor(), selectedFontColor: UIColor = UIColor(hex: 0x99999B)) {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
        button.setAttributedTitle(NSAttributedString(string:title, attributes:[ NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor]),
                                  forState: .Normal)
        button.setAttributedTitle(NSAttributedString(string:title, attributes:[ NSFontAttributeName: font, NSForegroundColorAttributeName: selectedFontColor]),
                                  forState: .Highlighted)

        self.init(customView:button)
    }
}

//MARK: Gesture Recognizer
extension UIBarButtonItem {
    public func setTapTarget(target: AnyObject?, selector: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: selector)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        customView?.addGestureRecognizer(tap)
    }
    
    public func setLongPressTarget(target: AnyObject?, selector: Selector) {
        let longPress = UILongPressGestureRecognizer(target:target, action:selector)
        longPress.minimumPressDuration = 0.25
        customView?.addGestureRecognizer(longPress)
    }
}

//+(UIBarButtonItem*)negativeSpacerWithWidth:(NSInteger)width {
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]
//        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//        target:nil
//        action:nil];
//    item.width = (width >= 0 ? -width : width);
//    return item;
//}
