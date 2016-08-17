//
//  flDevice.swift
//  Dining
//
//  Created by Nattapon Nimakul on 7/9/2558 BE.
//  Copyright © 2558 totizy@gmail.com. All rights reserved.
//

import Foundation

public enum FLDeviceOrientation: Int {
    case Portrait,            // Device oriented vertically, home button on the bottom
    Landscape       // Device oriented horizontally, home button on the right
}

public struct flDevice {
    public static func deviceOrientationForView(view: UIView) -> FLDeviceOrientation {
        switch UIApplication.sharedApplication().statusBarOrientation {
        // Portrait
        case .Portrait, .PortraitUpsideDown:
            return .Portrait

        // Landscape
        case .LandscapeRight, .LandscapeLeft:
            return .Landscape

        // Unknown
        case .Unknown:
            // Hardcode check default screen width
            if view.frame.size.width == 768 {
                return .Portrait
            } else {
                return .Landscape
            }
        }
    }
    
    public static func deviceOrientation() -> FLDeviceOrientation {
        switch UIApplication.sharedApplication().statusBarOrientation {
        // Portrait
        case .Portrait, .PortraitUpsideDown:
            return .Portrait
            
        // Landscape
        case .LandscapeRight, .LandscapeLeft:
            return .Landscape
            
        // Unknown
        case .Unknown:
            return .Portrait
        }
    }
}
