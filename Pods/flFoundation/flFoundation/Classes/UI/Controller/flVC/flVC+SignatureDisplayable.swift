//
//  flVC+SignatureDisplayable.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/29/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public protocol flVCSignatureDisplayable: class {
    var signView: flSignatureVC? { get set }
}

extension flVCSignatureDisplayable where Self: flVC, Self: flSignatureVCDelegate {
    // Signature View
    public func showSignView(data: ObjcDictionary?) {
        // Create
        let tmpVc = flFrameworkStoryboard.newVC(.SignatureOverlay)
        signView = tmpVc
        
        // Init
        signView?.delegate = self
        
        // Show
        addToWindow(signView?.view)
        
        // Animation
        signView?.workSpaceView?.appearScaleWidth(nil)
    }
    
    public func hideSignView() {
        signView?.view.removeFromSuperview()
        signView = nil
    }
    
}
