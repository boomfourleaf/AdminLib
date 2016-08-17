//
//  flVC+Overlay.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/12/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import UIKit

func rootWindow() -> UIWindow? {
    let appDelegate = UIApplication.sharedApplication().delegate
    // unknow reason appDelegate?.window can't be compiled, so use if let for workaround
    if let window = appDelegate?.window {
        return window
    } else {
        return nil
    }
}

func addToWindow(aView: UIView?) {
    if let uwpAView = aView {
        // Unknow reson but it does not have to correct orientation anymore
        //            aView?.rotateToCorrectOrientation()
        rootWindow()?.addSubview(uwpAView)
    }
}
