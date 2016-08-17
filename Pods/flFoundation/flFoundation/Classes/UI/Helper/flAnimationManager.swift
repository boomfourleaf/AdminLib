//
//  AnimationManager.swift
//  Dining
//
//  Created by Nattapon Nimakul on 12/13/2557 BE.
//  Copyright (c) 2557 nattapon@appsolutesoft.com. All rights reserved.
//

import Foundation

struct flAnimationManager {
    var userInteractionEnabledFrom: Bool? = false
    var userInteractionEnabledTo: Bool? = true
    var alphaFrom: CGFloat?
    var alphaTo: CGFloat?
    var transfromFrom: CGAffineTransform?
    var transfromTo: CGAffineTransform?
    var duration: NSTimeInterval = 0.5
    var delay: NSTimeInterval = 0.0
    var option: UIViewAnimationOptions = .CurveEaseInOut
    var moveCenterTo: CGPoint?
    
    func animate(view: UIView, finished: (()->())?) {
        if let uwpUserInteractionEnabledFrom = self.userInteractionEnabledFrom {
            view.userInteractionEnabled = uwpUserInteractionEnabledFrom
        }
        if let uwpAlphaFrom = self.alphaFrom {
            view.alpha = uwpAlphaFrom
        }
        if let uwpTransfromFrom = self.transfromFrom {
            view.transform = uwpTransfromFrom
        }
        
        Animate.duration(duration).delay(delay).options(option) {
            if let uwpAlphaTo = self.alphaTo {
                view.alpha = uwpAlphaTo
            }
            if let uwpTransfromTo = self.transfromTo {
                view.transform = uwpTransfromTo
            }
            if let uwpMoveCenterTo = self.moveCenterTo {
                view.center = uwpMoveCenterTo
            }
        }.task{
            if let uwpUserInteractionEnabledTo = self.userInteractionEnabledTo {
                view.userInteractionEnabled = uwpUserInteractionEnabledTo
            }
            
            finished?()
        }.run()
    }
}

extension flAnimationManager {
    
    // Appear
    static func appearManager() -> flAnimationManager {
        var manager = flAnimationManager()
        manager.alphaFrom = 0.0
        manager.alphaTo = 1.0
        return manager
    }
    
    static func appearScaleWidthManager() -> flAnimationManager {
        var manager = appearManager()
        manager.transfromFrom = CGAffineTransformMakeScale(0.1, 1)
        manager.transfromTo = CGAffineTransformMakeScale(1, 1)
        return manager
    }
    
    static func appearScaleHeightManager() -> flAnimationManager {
        var manager = appearManager()
        manager.transfromFrom = CGAffineTransformMakeScale(1, 0.1)
        manager.transfromTo = CGAffineTransformMakeScale(1, 1)
        return manager
    }
    
    // Disappear
    static func disappearManager() -> flAnimationManager {
        var manager = flAnimationManager()
        manager.alphaFrom = 1.0
        manager.alphaTo = 0.0
        return manager
    }
    
    static func disappearScaleWidthManager() -> flAnimationManager {
        var manager = disappearManager()
        manager.transfromFrom = CGAffineTransformMakeScale(1, 1)
        manager.transfromTo = CGAffineTransformMakeScale(0.1, 1)
        return manager
    }
    
    static func disappearScaleHeightManager() -> flAnimationManager {
        var manager = disappearManager()
        manager.transfromFrom = CGAffineTransformMakeScale(1, 1)
        manager.transfromTo = CGAffineTransformMakeScale(1, 0.1)
        return manager
    }
}
