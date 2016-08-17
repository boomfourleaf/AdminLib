//
//  flVC+OverlayMessageDisplayable.swift
//  Dining
//
//  Created by Nattapon Nimakul on 5/29/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import UIKit

public protocol flVCOverlayMessageDisplayable: class {
    var overlayMessage: UIViewController? { get set }
}

extension flVCOverlayMessageDisplayable {
    public func showOverlayOrderComplete(data: ObjcDictionary?) {
        // Create
        let tmpVc = flFrameworkStoryboard.newVC(.MessageOverlay)
        overlayMessage = tmpVc
        
        // Show
        addToWindow(overlayMessage?.view)
        
        // Calculate animation end point
        var moveTo: CGPoint?
        if let overlayView = overlayMessage?.view.viewWithTag(10) {
            if var windowFrame = rootWindow()?.frame {
                // Landscape
                if flDevice.deviceOrientation() == .Landscape {
                    windowFrame.setWH(windowFrame.size.height, height: windowFrame.size.width)
                }
                moveTo = CGPointMake(windowFrame.size.width - overlayView.frame.size.width/3/2,
                                     windowFrame.size.height - overlayView.frame.size.height/3/2)
            }
        }
        
        // Animation
        overlayMessage?.view.appearScaleHeightAndMoveTo(moveTo) {
            self.overlayMessage?.view?.removeFromSuperview()
            self.overlayMessage = nil
        }
    }
    
    public func showOverlayMessageToOrderList(data: ObjcDictionary?) {
        // Create
        let tmpVc = flFrameworkStoryboard.newVC(.MessageOverlay)
        overlayMessage = tmpVc
        
        // Init
        overlayMessage?.view?.labelWithTag(20)?.text = String(orEmpty: data?["message"])
        
        // Show
        addToWindow(overlayMessage?.view)
        
        // Calculate animation end point
        var moveTo: CGPoint?
        if let overlayView = overlayMessage?.view.viewWithTag(10) {
            if var windowFrame = rootWindow()?.frame {
                // Landscape
                if flDevice.deviceOrientation() == .Landscape {
                    windowFrame.setWH(windowFrame.size.height, height: windowFrame.size.width)
                }
                moveTo = CGPointMake(windowFrame.size.width - overlayView.frame.size.width/3/2,
                                     overlayView.frame.size.height/3/2 + CGFloat(UI_STATUS_BAR_HEIGHT))
            }
        }
        
        // Animation
        overlayMessage?.view.appearScaleHeightAndMoveTo(moveTo) {
            self.overlayMessage?.view?.removeFromSuperview()
            self.overlayMessage = nil
        }
    }
    
    public func showOverlayMessage(data: ObjcDictionary?) {
        // Create
        let tmpVc = flFrameworkStoryboard.newVC(.MessageOverlay)
        overlayMessage = tmpVc
        
        // Init
        overlayMessage?.view?.labelWithTag(20)?.text = String(orEmpty: data?["message"])
        
        // Show
        addToWindow(overlayMessage?.view)
        
        // Animation
        overlayMessage?.view.appearScaleHeightAndOut() {
            self.overlayMessage?.view?.removeFromSuperview()
            self.overlayMessage = nil
        }
    }
}
