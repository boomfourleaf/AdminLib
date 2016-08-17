//
//  flVC+LoadingDisplayable.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/29/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

public protocol flVCLoadingDisplayable: class {
    var loadingView: flLoadingScreenVC? { get set }
}


extension flVCLoadingDisplayable where Self: flVC {
    // Loading View
    public func showLoadingView() {
        // Create
        let vc = flFrameworkStoryboard.newVC(.LoadingOverlay)
        loadingView = vc
        
        // Init
        loadingView?.enableAnimation = true
        
        // Show
        addToWindow(loadingView?.view)
    }
    
    public func hideLoadingView() {
        loadingView?.stopAnimation()
        loadingView?.view.removeFromSuperview()
        loadingView = nil
    }
}
