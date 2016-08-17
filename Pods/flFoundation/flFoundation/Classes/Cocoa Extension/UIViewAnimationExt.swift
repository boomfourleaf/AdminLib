//
//  UIViewAnimationExt.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/13/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

extension UIView {
    public func appearScaleWidth(finished: (()->())?) {
        var manager = flAnimationManager.appearScaleWidthManager()
        manager.duration = 0.5
        manager.delay = 0.0
        manager.option = .CurveEaseOut
        manager.animate(self, finished: finished)
    }
    
    public func appearScaleHeight(finished: (()->())?) {
        var manager = flAnimationManager.appearScaleHeightManager()
        manager.duration = 0.5
        manager.delay = 0.0
        manager.option = .CurveEaseOut
        manager.animate(self, finished: finished)
    }
    
    public func disappearScaleWidth(finished: (()->())?) {
        var manager = flAnimationManager.disappearScaleWidthManager()
        manager.duration = 0.5
        manager.delay = 0.0
        manager.option = .CurveEaseOut
        manager.animate(self, finished: finished)
    }
    
    public func disappearScaleHeight(finished: (()->())?) {
        var manager = flAnimationManager.disappearScaleHeightManager()
        manager.duration = 0.5
        manager.delay = 0.0
        manager.option = .CurveEaseOut
        manager.animate(self, finished: finished)
    }
    
    public func appearScaleHeightAndOut(finished: ()->()) {
        appearScaleHeight() {
            var manager = flAnimationManager.disappearScaleHeightManager()
            manager.duration = 0.5
            manager.delay = 1.0
            manager.option = .CurveEaseOut
            manager.userInteractionEnabledTo = false
            manager.animate(self, finished: finished)
        }
    }
    
    public func appearScaleHeightAndMoveTo(moveTo: CGPoint?, finished: ()->()) {
        appearScaleHeight() {
            var manager = flAnimationManager.disappearScaleHeightManager()
            manager.duration = 0.5
            manager.delay = 1.0
            manager.alphaTo = 0.2
            manager.transfromTo = CGAffineTransformMakeScale(1.0/3.0, 1.0/3.0)
            manager.moveCenterTo = moveTo
            manager.option = .CurveEaseOut
            manager.userInteractionEnabledTo = false
            manager.animate(self, finished: finished)
        }
    }
}
